class PlayerCanMovePolicy
  def initialize(player:)
    @player = player
  end

  # Policy for determining if a player can move
  # A player can move provided that they can use any of their tickets
  # This policy doesn't check whether a player 'may' move (i.e., is the game on-going? Has the round finished? Is it their
  # turn? etc.).
  def can_move?
    ticket_counts = @player.ticket_counts

    # Performs an optimisation to prevent unnecessary SQL queries
    # Since all nodes support taxi and black tickets, the player may naturally move if they have any
    return true if ticket_counts.values_at(:taxi, :black).reduce(&:+) > 0

    policy = PlayerCanUseTicketPolicy.new(player: @player)
    (Move::TICKET_TYPES - [:double_move]).any? do |ticket|
      policy.can_use?(ticket: ticket, count: ticket_counts[ticket])
    end
  end
end

