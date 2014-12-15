class RoundsController < GamesController::Base
  before_action :load_current_round, only: [:current]
  respond_to :json

  caches_page :current

  def current
    render json: @current_round
  end

  private

  def load_current_round
    @current_round = @game.current_round
  end
end

