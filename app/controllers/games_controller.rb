class GamesController < SessionsController::Base
  class Base < SessionsController::Base
    include UsersHelper

    before_action :load_game
    before_action :load_current_user_player
    before_action :validate_game

    private

    def load_game
      @game = Game.includes(players: [moves: :to_node], rounds: [moves: :to_node]).find(params[:game_id])
    end

    def load_current_user_player
      @current_user_player = player(game: @game, user: @current_user)
    end

    def validate_game
      head :unauthorized unless @current_user_player
    end
  end

  before_action :load_games, only: [:index]
  before_action :load_game, only: [:show]
  respond_to :html

  def new
    @game = Game.new
  end

  def show
    if @game.finished?
      render :finished
    elsif @game.initialising?
      render_game_initialising
    elsif @game.ongoing?
      render_game_ongoing
    end
  end

  def create
    @game = Game.new(game_params)

    if @game.save
      redirect_to @game
    else
      render :new, alert: @game.errors.full_messages
    end
  end

  private

  def load_games
    # Exclude games that are finished or on-going games that don't include the current user
    @games = Game.includes(:players).reject do |game|
      game.finished? || (game.ongoing? && @current_user.games.exclude?(game))
    end
  end

  def load_game
    @game = Game.find(params[:id])
  end

  def game_params
    params.require(:game).permit(:name)
  end

  def render_game_initialising
    if @current_user.games.include?(@game)
      render :waiting
    else
      @player = Player.new

      render :join
    end
  end

  def render_game_ongoing
    if @current_user.games.include?(@game)
      render :ongoing
    else
      head :unauthorized
    end
  end
end

