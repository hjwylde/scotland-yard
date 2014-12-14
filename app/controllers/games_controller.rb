class GamesController < UsersController::Base
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
    @games = Game.includes(:players).all.select(&:initialising?)
  end

  def load_game
    @game = Game.find(params[:id])
  end

  def game_params
    params.require(:game).permit(:name)
  end

  def render_game_initialising
    if current_user.try!(:game) == @game
      render :waiting
    else
      @player = Player.new

      render :join
    end
  end

  def render_game_ongoing
    if current_user.try!(:game) == @game
      render :ongoing
    else
      render status: :unauthorized
    end
  end
end

