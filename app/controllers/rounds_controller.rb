class RoundsController < GamesControllerBase
  before_action :load_current_round, only: :current
  respond_to :json

  def current
    render json: @current_round
  end

  private

  def load_current_round
    @current_round = @game.current_round
  end
end

