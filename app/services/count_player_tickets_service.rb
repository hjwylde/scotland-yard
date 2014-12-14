class CountPlayerTicketsService
  def initialize(player:)
    @player = player
  end

  def call
    tickets_count = @player.starting_tickets_count.merge(used_tickets_count(@player)) { |key, old, new| old - new }

    if @player.detective?
      tickets_count
    else
      # A criminal also gets all of the detectives' used tickets
      @player.game.detectives.reduce(tickets_count) do |total, detective|
        total.merge(used_tickets_count(detective)) { |key, old, new| old + new }
      end
    end
  end

  private

  def used_tickets_count(player)
    player.moves.group(:ticket).count.symbolize_keys
  end
end

