class GamesController < UsersController
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
      if @user.try!(:game) == @game
        render :waiting
      else
        @player = Player.new

        render :join
      end
    elsif @game.ongoing?
      if @user.try!(:game) == @game
        render :ongoing
      else
        render status: :unauthorized
      end
    else
      render status: :internal_server_error
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
end

