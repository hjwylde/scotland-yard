class CountPlayerTicketsService
  def initialize(player:)
    @player = player
  end

  def call
    ticket_counts = @player.starting_ticket_counts.merge(used_ticket_counts(@player)) { |key, old, new| old - new }

    if @player.detective?
      ticket_counts
    else
      # A criminal also gets all of the detectives' used tickets
      @player.game.detectives.reduce(ticket_counts) do |total, detective|
        total.merge(used_ticket_counts(detective)) { |key, old, new| old + new }
      end
    end
  end

  private

  def used_ticket_counts(player)
    ticket_counts = player.moves.group(:ticket).count.symbolize_keys
    # Double move tickets are counted by the rounds with only a single player in them
    ticket_counts[:double_move] = (player.game.rounds.extra & player.rounds).length

    ticket_counts
  end
end

