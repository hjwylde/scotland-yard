class RouteSerializer < ActiveModel::Serializer
  attributes :from_node_id, :to_node_id, :transport_mode
end

