class Board
  attr_reader :nodes, :routes, :node_routes, :adjacency_list

  def initialize(nodes:, routes:)
    @nodes, @routes = nodes, routes

    @node_routes = Hash.new { |hash, key| hash[key] = [] }
    routes.each do |route|
      [route.from_node_id, route.to_node_id].each do |node_id|
        @node_routes[node_id] << route
      end
    end

    @adjacency_list = @node_routes.reduce({}) do |hash, (node_id, routes)|
      hash.merge!(node_id => (routes.flat_map { |route| [route.from_node_id, route.to_node_id] }).uniq - [node_id])
    end
  end
end

