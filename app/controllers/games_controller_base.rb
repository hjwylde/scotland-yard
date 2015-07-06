class GamesControllerBase < SessionsControllerBase
  before_action :load_game
  before_action :load_current_player
  before_action :validate_game

  private

  def load_game
    @game = Game.preload(players: [moves: :to_node], rounds: [moves: :to_node]).find(params[:game_id].to_i)
  end

  def load_current_player
    @current_player = @game.players.find_by(user_id: @current_user.id)
  end

  def validate_game
    head :forbidden unless @current_player
  end
end

