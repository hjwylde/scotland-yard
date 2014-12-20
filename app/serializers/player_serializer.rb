class PlayerSerializer < ActiveModel::Serializer
  attributes :id, :type, :name, :current_node_id, :ticket_counts
end

