class StartRoundService
  include Wisper::Publisher

  def initialize(game:)
    @game = game
  end

  def call(override_round_finished_policy: false)
    if @game.finished?
      publish(:fail, ['Game has finished'])
    elsif @game.current_round.try!(:ongoing?) && !override_round_finished_policy
      publish(:fail, ['Current round has not finished'])
    else
      round = @game.rounds.new(number: next_round_number)

      if round.save
        publish :success, round
      else
        publish :fail, round.errors.full_messages
      end
    end
  end

  private

  def next_round_number
    if @game.initialising?
      Round::STARTING_ROUND_NUMBER
    else
      @game.current_round.number + 1
    end
  end
end

