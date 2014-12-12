class RoundSerializer < ActiveModel::Serializer
  attributes :id, :number, :moves_count

  def moves_count
    object.moves.count
  end
end

