class RoundsController < ApplicationController
  before_action :load_game, only: [:current]
  before_action :load_current_round, only: [:current]
  respond_to :json

  caches_page :current

  def current
    render json: @current_round
  end

  private

  def load_game
    @game = Game.find(params[:game_id])
  end

  def load_current_round
    @current_round = @game.current_round
  end
end

