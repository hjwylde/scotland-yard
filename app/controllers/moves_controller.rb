class MovesController < GamesControllerBase
  before_action :load_player, only: :create
  before_action :validate_player, only: :create
  respond_to :json

  def create
    to_node = Node.find(move_params[:to_node_id])
    ticket = move_params[:ticket]

    double_move = params[:double_move] == 'true'

    ticket_counts = CountPlayerTicketsService.new(game: @game).call

    make_move = MakeMoveService.new(player: @player, to_node: to_node, ticket: ticket, cache: { ticket_counts: ticket_counts })
    make_move.on :success do
      # TODO: Move this to the make move service and have a check that the player actually has a
      # double move ticket
      policy = RoundFinishedPolicy.new(round: @game.current_round)
      if @game.ongoing? && (policy.finished? || double_move_valid(double_move, ticket_counts))
        start_round = StartRoundService.new(game: @game)
        start_round.on :fail do |errors|
          render json: { errors: errors }, status: :internal_server_error
          return
        end

        start_round.call(override_round_finished_policy: double_move)
      end

      render json: @move, status: :created
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
    params.require(:move).permit(:to_node_id, :ticket)
  end

  # TODO: Make this a policy?
  def double_move_valid(double_move, ticket_counts)
    double_move && @player.criminal? && (ticket_counts[@player.id][:double_move] > 0)
  end
end

