class RoutesController < ApplicationController
  before_action :load_routes, only: :index
  respond_to :json

  caches_page :index

  def index
    render json: @routes
  end

  private

  def load_routes
    @routes = Route.all
  end
end

