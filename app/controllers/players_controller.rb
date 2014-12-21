class PlayersController < GamesControllerBase
  before_action :load_players, only: :index
  before_action :load_ticket_counts, only: :index
  before_action :load_active_player, only: :active
  respond_to :html, :json

  # Don't check that the user has a player in the current game if we're creating a player for them
  skip_before_action :validate_game, only: :create

  def index
    respond_to do |format|
      format.html do
        load_active_player

        render partial: 'players'
      end
      format.json do
        # TODO: Doesn't belong here
        # Don't reveal the criminal to the detectives in the API
        @players = @players.detectives unless @players.criminals.map(&:user_id).include?(@current_user.id)

        render json: @players, ticket_counts: @ticket_counts
      end
    end
  end

  def active
    render json: { id: @active_player.try!(:id) }
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
    @players = @game.players
  end

  def load_ticket_counts
    @ticket_counts = CountPlayerTicketsService.new(game: @game).call
  end

  def load_active_player
    @active_player = GetActivePlayerService.new(game: @game).call
  end

  def player_params
    params.require(:player).permit(:name, :type)
  end
end

