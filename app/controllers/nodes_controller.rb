require_relative '../concepts/board'

class NodesController < ApplicationController
  before_action :load_nodes, only: :index
  before_action :load_routes, only: :index
  before_action :load_board, only: :index
  respond_to :json

  caches_page :index

  def index
    render json: @nodes, board: @board
  end

  private

  def load_nodes
    @nodes = Node.all
  end

  def load_routes
    @routes = Route.all
  end

  def load_board
    @board = Board.new(nodes: @nodes, routes: @routes)
  end
end

