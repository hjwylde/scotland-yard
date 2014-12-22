class MovesController < GamesControllerBase
  before_action :load_player, only: :create
  before_action :validate_player, only: :create
  respond_to :json

  def create
    to_node = Node.find(move_params[:to_node_id])
    ticket = move_params[:ticket]
    token = move_params[:token] unless move_params[:token].nil? || move_params[:token].try!(:empty?)

    ticket_counts = CountPlayerTicketsService.new(game: @game).call
    token_counts = CountPlayerTokensService.new(game: @game).call

    make_move = MakeMoveService.new(player: @player, to_node: to_node, ticket: ticket, token: token,
                                    cache: { ticket_counts: ticket_counts, token_counts: token_counts })
    make_move.on :success do |move|
      render json: move, status: :created
    end
    make_move.on :fail do |errors|
      render json: { errors: errors }, status: :unprocessable_entity
    end

    make_move.call
  end

  private

  def load_player
    @player = Player.find(params[:player_id])
  end

  def validate_player
    head :unauthorized if @player.game != @game
    head :unauthorized if @player.user != @current_user
  end

  def move_params
    params.require(:move).permit(:to_node_id, :ticket, :token)
  end
end

