class PlayerSerializer < ActiveModel::Serializer
  attributes :id, :type, :name, :current_node_id, :players_turn, :ticket_counts

  # TODO: Re-name to 'turn'
  # The standard query is extremely inefficient when trying to determine if it is the player's
  # turn
  # This optimises it by calculating the current player beforehand and passing it in
  def players_turn
    if serialization_options.has_key?(:current_player)
      current_player && object.id == current_player.id
    else
      Rails.logger.warn('Unoptimised call to PlayerSerializer: it should include a :current_player argument')

      object.game.started? && PlayerTurnPolicy.new(round: object.game.current_round).turn_of?(object)
    end
  end

  private

  def current_player
    serialization_options[:current_player]
  end
end

