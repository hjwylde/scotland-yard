class PlayersController < GamesController::Base
  before_action :load_players, only: [:index]
  before_action :load_current_player, only: [:index]
  respond_to :html, :json

  caches_page :index

  # Don't check that the user has a player in the current game if we're creating a player for them
  skip_before_action :validate_game, only: :create

  def index
    if request.xhr? && request.format == 'html'
      render partial: 'players'
      return
    end

    render json: @players, current_player: @current_player
  end

  def create
    create_player = CreatePlayerService.new(game: @game, user: @current_user)
    create_player.on :fail do |errors|
      render json: { errors: errors }, status: :internal_server_error
      return
    end
    create_player.on :success do |player|
      @player = player
    end

    create_player.call(player_params)

    redirect_to @game
  end

  private

  def load_players
    @players = @game.players.ordered
  end

  def load_current_player
    @current_player = GetCurrentPlayerService.new(game: @game).call
  end

  def player_params
    params.require(:player).permit(:name, :type)
  end
end

