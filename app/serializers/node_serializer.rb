class NodeSerializer < ActiveModel::Serializer
  attributes :id, :origin, :fixed, :x, :y, :linked_node_ids, :transport_modes

  # The standard query is extremely inefficient when trying to get the linked node ids for all
  # nodes
  # This optimises it by using a single query (of all routes) and performing a soft selection
  # to calculate the linked node ids
  def linked_node_ids
    if node_routes
      (node_routes[object.id].flat_map { |route| [route.from_node_id, route.to_node_id] }).uniq - [object.id]
    else
      Rails.logger.warn('Unoptimised call to NodeSerializer: it should include a :node_routes argument')

      object.linked_node_ids
    end
  end

  # As per above, this attribute is optimised when passed all routes
  def transport_modes
    if node_routes
      node_routes[object.id].map(&:transport_mode).uniq
    else
      Rails.logger.warn('Unoptimised call to NodeSerializer: it should include a :node_routes argument')

      object.transport_modes
    end
  end

  # TODO: Remove fixed
  def fixed
    object.x.present? && object.y.present?
  end

  private

  def node_routes
    @options[:node_routes]
  end
end

