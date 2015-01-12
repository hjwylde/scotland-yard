class CountPlayerTickets
  def initialize(game:)
    @game = game
  end

  def call
    ticket_counts = Hash.new do |hash, player_id|
      hash[player_id] = @game.players.find(player_id).starting_ticket_counts
    end

    used_ticket_counts.each do |player_id, counts|
      ticket_counts[player_id].merge!(counts) { |ticket, starting_count, used_count| starting_count - used_count }

      # The criminal gets all of the detectives' used tickets
      if @game.players.find(player_id).detective?
        @game.criminals.each do |criminal|
          ticket_counts[criminal.id].merge!(counts) { |ticket, criminal_count, detective_count| criminal_count + detective_count }
        end
      end
    end

    ticket_counts
  end

  private

  def used_ticket_counts
    # Returns a hash {[:player_id, 'ticket'] => count}
    ticket_counts = @game.players.joins(:moves).group(:player_id, :ticket).count
    # Creates an array [[:player_id, :ticket, count]] and then a hash {player_id: [[:player_id,
    # :ticket, count]]}
    ticket_counts = ticket_counts.map { |key, value| [key.first, key.second.to_sym, value] }.group_by { |player_id, ticket, count| player_id }
    # Creates a hash {player_id: {ticket: count}}
    ticket_counts.each do |key, values|
      ticket_counts[key] = Hash[values.map { |value| value[1..-1] }]
    end

    ticket_counts
  end
end

