class PlayerCanMovePolicy
  include Wisper::Publisher

  def initialize(player:, cache: Hash.new({}))
    @player = player
    @cache = cache

    @errors = []
  end

  # Policy for determining if a player can move
  # A player can move provided that
  # 1) they can use any of their tickets
  def can_move?
    counts = ticket_counts

    # Performs an optimisation to prevent unnecessary SQL queries
    # Since all nodes support taxi and black tickets, the player may naturally move if they have any
    return true if counts.values_at(:taxi, :black).reduce(&:+) > 0

    check_player_can_use_tickets(counts)

    publish(:fail, @errors) if @errors.any?

    @errors.empty?
  end

  private

  def check_player_can_use_tickets(counts)
    if !player_can_use_tickets(counts)
      @errors << 'You cannot use any tickets'
    end
  end

  def player_can_use_tickets(counts)
    policy = PlayerCanUseTicketPolicy.new(player: @player)
    Move::TICKET_TYPES.any? do |ticket|
      policy.can_use?(ticket: ticket, count: counts[ticket]) if counts[ticket] > 0
    end
  end

  def ticket_counts
    (@cache[:ticket_counts] || CountPlayerTickets.new(game: @player.game).call)[@player.id]
  end
end

