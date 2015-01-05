class GameSerializer < ActiveModel::Serializer
  attributes :id, :name, :player_count, :max_player_count, :status

  def player_count
    object.player_ids.count
  end

  def max_player_count
    Game::NUMBER_OF_PLAYERS
  end

  def status
    case
    when object.initialising?
      :initialising
    when object.ongoing?
      :ongoing
    else
      # object.finished?
      :finished
    end
  end
end

