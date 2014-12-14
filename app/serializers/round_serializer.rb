class RoundSerializer < ActiveModel::Serializer
  attributes :id, :number, :move_count

  def move_count
    object.moves.count
  end
end

