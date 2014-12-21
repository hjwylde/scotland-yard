class PlayerCanMovePolicy
  include Wisper::Publisher

  def initialize(player:, cache: Hash.new({}))
    @player = player
    @cache = cache

    @errors = []
  end

  # Policy for determining if a player can move
  # A player can move provided that they can use any of their tickets
  # This policy doesn't check whether a player 'may' move (i.e., is the game on-going? Has the round finished? Is it their
  # turn? etc.).
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
    # TODO: Double move tickets should be separate
    (Move::TICKET_TYPES - [:double_move]).any? do |ticket|
      if counts[ticket] > 0
        policy.can_use?(ticket: ticket, count: counts[ticket])
      end
    end
  end

  def ticket_counts
    @cache[:ticket_counts][@player.id] || @player.ticket_counts
  end
end

