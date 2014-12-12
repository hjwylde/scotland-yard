class StartRoundService
  include Wisper::Publisher

  def initialize(game:)
    @game = game
  end

  def call
    publish(:fail, ['Game has finished']) and return if @game.finished?
    publish(:fail, ['Current round has not finished']) and return if @game.current_round && @game.current_round.ongoing?

    round = if @game.initialising?
      @game.rounds.new(number: Round::STARTING_ROUND_NUMBER)
    else
      @game.rounds.new(number: @game.current_round.number + 1)
    end

    if round.save
      publish :success, round
    else
      publish :fail, round.errors.full_messages
    end

    nil
  end
end

