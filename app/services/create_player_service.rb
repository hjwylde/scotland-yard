class CreatePlayerService
  include Wisper::Publisher

  def initialize(game:)
    @game = game
  end

  def call(player_params)
    player = @game.players.new(player_params)

    if !GameValidPolicy.new(game: @game).valid?
      publish :fail, ['Player was unable to be created']
    elsif !player.save
      publish :fail, player.errors.full_messages
    else
      # TODO: How to handle transactions here?
      if @game.players.count == Game::NUMBER_OF_PLAYERS
        start_round = StartRoundService.new(game: @game)
        start_round.on :fail do |errors|
          publish :fail, errors
          return
        end

        start_round.call
      end

      publish :success, player
    end
  end
end

