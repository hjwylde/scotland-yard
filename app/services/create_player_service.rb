class CreatePlayerService
  include Wisper::Publisher

  def initialize(game:, user:)
    @game, @user = game, user
  end

  def call(player_params)
    player = @user.players.new(player_params.merge({ game_id: @game.id }))

    if (@user.players & @game.players).any?
      publish :fail, ['You have already joined this game']
    elsif !GameValidPolicy.new(game: @game).valid?
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

