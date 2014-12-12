class NodesController < ApplicationController
  before_action :load_nodes, only: [:index]
  respond_to :json

  caches_page :index

  def index
    render json: @nodes, routes: Route.all
  end

  private

  def load_nodes
    @nodes = Node.all
  end
end

