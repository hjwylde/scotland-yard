class PlayerCanUseTicketPolicy
  def initialize(player:)
    @player = player
  end

  # Policy for determining if a player can use a given ticket
  # A player can use a ticket provided that:
  # 1) they have more than 0 of that ticket type and,
  # 2) the player's current node supports that ticket type
  # A player cannot use a ticket if the game has finished
  # This policy doesn't check whether a player 'may' use a ticket (i.e., is the game on-going? Has the round finished? Is it their
  # turn? etc.).
  def can_use?(ticket:, count:)
    count > 0 && player_current_node_supports?(ticket.to_sym)
  end

  private

  def player_current_node_supports?(ticket)
    # Performs a simple optimisation to prevent unnecessary SQL queries
    # All nodes support taxi and black tickets
    [:taxi, :black].include?(ticket) || @player.current_node.transport_modes.include?(ticket)
  end
end

