class MovesController < GamesController::Base
  before_action :load_player, only: [:create]
  before_action :validate_player, only: [:create]
  respond_to :json

  def create
    to_node = Node.find(move_params[:to_node_id])
    ticket = move_params[:ticket]

    make_move = MakeMoveService.new(player: @player, to_node: to_node, ticket: ticket)
    make_move.on :success do
      if @game.ongoing? && @game.current_round.finished?
        start_round = StartRoundService.new(game: @game)
        start_round.on :fail do |errors|
          render json: { errors: errors }, status: :internal_server_error
          return
        end

        start_round.call
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
end

