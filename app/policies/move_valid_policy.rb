class MoveValidPolicy
  include Wisper::Publisher

  def initialize(player:, to_node:, ticket:, cache: Hash.new({}))
    @player, @to_node, @ticket = player, to_node, ticket.to_sym
    @cache = cache

    @errors = []
  end

  def valid?
    check_player_can_use_ticket
    check_is_turn_of_player
    check_route_exists
    check_destination_is_empty

    publish(:fail, @errors) if @errors.any?

    @errors.empty?
  end

  private

  def check_player_can_use_ticket
    if !PlayerCanUseTicketPolicy.new(player: @player).can_use?(ticket: @ticket, count: ticket_counts[@ticket])
      @errors << "You cannot use a #{@ticket} ticket"
    end
  end

  def check_is_turn_of_player
    unless PlayerTurnPolicy.new(game: @player.game).turn_of?(@player)
      @errors << "It's not your turn"
    end
  end

  def check_route_exists
    node_ids = [@player.current_node_id, @to_node.id]

    unless Route.where(from_node_id: node_ids.min, to_node_id: node_ids.max, transport_mode: @ticket).exists?
      @errors << "There's no route to #{@to_node.id} using a #{@ticket} ticket"
    end
  end

  def check_destination_is_empty
    if @player.detective? && @player.game.detectives.map(&:current_node_id).include?(@to_node.id)
      @errors << 'Someone else is already there'
    end
  end

  def ticket_counts
    @cache[:ticket_counts][@player.id] || @player.ticket_counts
  end
end

