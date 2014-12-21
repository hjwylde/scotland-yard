class NodesController < ApplicationController
  before_action :load_nodes, only: :index
  before_action :load_routes, only: :index
  before_action :load_node_routes, only: :index
  respond_to :json

  caches_page :index

  def index
    render json: @nodes, node_routes: @node_routes
  end

  private

  def load_nodes
    @nodes = Node.all
  end

  def load_routes
    @routes = Route.all
  end

  def load_node_routes
    # TODO: Maybe put this into a concept?
    @node_routes = Hash.new { |hash, key| hash[key] = [] }
    @routes.each do |route|
      [route.from_node_id, route.to_node_id].each do |node_id|
        @node_routes[node_id] << route
      end
    end
  end
end

