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
    @player = @game.players.new(player_params)

    policy = GameValidPolicy.new(game: @game)

    if !policy.valid?
      redirect_to @game, alert: ['Player was unable to be created']
    elsif !@player.save
      redirect_to @game, alert: @player.errors.full_messages
    else
      start_game if @game.players.count == Game::NUMBER_OF_PLAYERS

      redirect_to @game
    end
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
    session[:user_id] = @player.id
  end

  def player_params
    params.require(:player).permit(:name, :type)
  end

  def start_game
    start_round = StartRoundService.new(game: @game)
    start_round.on :fail do |errors|
      render json: { errors: errors }, status: :internal_server_error
      return
    end

    start_round.call
  end
end

