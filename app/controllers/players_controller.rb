class PlayersController < ApplicationController
  before_action :load_game, only: [:index, :create]
  before_action :load_players, only: [:index]
  before_action :load_current_player, only: [:index]
  after_action :save_user, only: [:create]
  respond_to :html, :json

  caches_page :index

  def index
    if request.xhr? && request.format == 'html'
      render partial: 'players'
      return
    end

    render json: @players, each_serializer: PlayerSerializer, current_player: @current_player
  end

  def create
    create_player = CreatePlayerService.new(game: @game)
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

  def load_game
    @game = Game.includes(players: [moves: :to_node], rounds: [moves: :to_node]).find(params[:game_id])
  end

  def load_players
    @players = @game.players.ordered
  end

  def load_current_player
    @current_player = GetCurrentPlayerService.new(game: @game).call
  end

  def save_user
    session[:user_id] = @player.id if @player
  end

  def player_params
    params.require(:player).permit(:name, :type)
  end
end

