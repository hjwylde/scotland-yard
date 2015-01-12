class PlayersController < GamesControllerBase
  before_action :load_players, only: :index
  before_action :load_ticket_counts, only: :index
  before_action :load_token_counts, only: :index
  before_action :load_active_player, only: :active
  respond_to :html, :json

  # Don't check that the user has a player in the current game if we're creating a player for them
  skip_before_action :validate_game, only: :create

  def index
    render json: @players, current_player: @current_player, ticket_counts: @ticket_counts, token_counts: @token_counts
  end

  def active
    render json: { id: @active_player.try!(:id) }
  end

  def create
    create_player = CreatePlayer.new(game: @game, user: @current_user)
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
    @players = @game.players
  end

  def load_ticket_counts
    @ticket_counts = CountPlayerTickets.new(game: @game).call
  end

  def load_token_counts
    @token_counts = CountPlayerTokens.new(game: @game).call
  end

  def load_active_player
    @active_player = GetActivePlayer.new(game: @game).call
  end

  def player_params
    params.require(:player).permit(:name, :type)
  end
end

