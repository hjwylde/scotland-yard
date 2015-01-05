class StartRoundService
  include Wisper::Publisher

  def initialize(game:)
    @game = game

    @errors = []
  end

  # Starts a new round in the game
  # Supports overriding the round finished policy (which checks that all movable players have moved)
  # in order to allow for the criminal to make double moves
  def call(override_round_finished_policy: false)
    check_game_not_finished
    check_current_round_finished if @game.current_round && !override_round_finished_policy

    round = create_round

    if @errors.empty?
      publish :success, round
    else
      publish :fail, @errors
    end
  end

  private

  def check_game_not_finished
    if @game.finished?
      @errors << 'Game has finished'
    end
  end

  def check_current_round_finished
    policy = RoundFinishedPolicy.new(round: @game.current_round)
    if !policy.finished?
      @errors << 'Current round has not finished'
    end
  end

  def create_round
    round = @game.rounds.new(number: next_round_number)
    if !round.save
      @errors += round.errors.full_messages
    end

    round
  end

  def next_round_number
    if @game.initialising?
      Round::STARTING_ROUND_NUMBER
    else
      @game.current_round.number + 1
    end
  end
end

