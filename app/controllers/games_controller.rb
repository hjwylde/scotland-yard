class GamesController < SessionsControllerBase
  before_action :load_games, only: :index
  before_action :load_game, only: :show
  respond_to :html, :json

  def index
    respond_to do |format|
      format.html { render :index }
      format.json { render json: @games }
    end
  end

  def show
    respond_to do |format|
      format.html {
        if @game.finished?
          render :finished
        elsif @game.initialising?
          render_game_initialising
        elsif @game.ongoing?
          render_game_ongoing
        end
      }
      format.json { render json: @game }
    end
  end

  def new
    @game = Game.new
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
    @games = UserGames.new(user: @current_user).call
  end

  def load_game
    @game = Game.find(params[:id])
  end

  def game_params
    params.require(:game).permit(:name)
  end

  def render_game_initialising
    # TODO: Swap this round so it uses the game to check if it contains the current user
    if @current_user.games.include?(@game)
      render :waiting
    else
      @player = Player.new

      render :join
    end
  end

  def render_game_ongoing
    # TODO: Swap this round so it uses the game to check if it contains the current user
    if @current_user.games.include?(@game)
      render :ongoing
    else
      head :forbidden
    end
  end
end

