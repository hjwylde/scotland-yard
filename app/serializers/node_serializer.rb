class NodeSerializer < ActiveModel::Serializer
  attributes :id, :origin, :x, :y, :adjacent_node_ids, :transport_modes

  # The standard query is extremely inefficient when trying to get the adjacent node ids for all
  # nodes
  # This optimises it by using a single query (of all routes) and performing a soft selection
  # to calculate the adjacent node ids
  def adjacent_node_ids
    if board
      board.adjacency_list[object.id]
    else
      Rails.logger.warn 'Unoptimised call to NodeSerializer: it should include a :board argument'

      object.adjacent_node_ids
    end
  end

  # As per above, this attribute is optimised when passed a board
  def transport_modes
    if board
      board.node_routes[object.id].map(&:transport_mode).uniq
    else
      Rails.logger.warn 'Unoptimised call to NodeSerializer: it should include a :board argument'

      object.transport_modes
    end
  end

  private

  def board
    @options[:board]
  end
end

