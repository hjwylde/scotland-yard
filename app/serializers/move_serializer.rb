class MoveSerializer < ActiveModel::Serializer
  attributes :to_node_id, :ticket

  def to_node_id
    object.to_node_id if object.player.detective? || ShowCriminalMovePolicy.new(move: object).show?
  end
end

