class MakeMoveService
  include Wisper::Publisher

  def initialize(player:, to_node:, ticket:)
    @player, @to_node, @ticket = player, to_node, ticket.to_sym
  end

  def call
    if !PlayerCanMovePolicy.new(player: @player).can_move?
      publish :fail, ['You have no tickets left']
    elsif !PlayerTurnPolicy.new(round: @player.game.current_round).turn_of?(@player)
      publish :fail, ["It's not your turn"]
    elsif @player.detective? && @player.game.detectives.map(&:current_node).detect { |node| node == @to_node }
      publish :fail, ['Someone else is already there']
    elsif !route_exists
      publish :fail, ["You can't move to #{@to_node.id} with a #{@ticket} ticket"]
    else
      move = @player.moves.new(round: @player.game.current_round, to_node: @to_node, ticket: @ticket)

      if move.save
        publish :success, move
      else
        publish :fail, move.errors.full_messages
      end
    end
  end

  private

  def route_exists
    node_ids = [@player.current_node.id, @to_node.id]

    Route.where(from_node_id: node_ids.min, to_node_id: node_ids.max, transport_mode: @ticket).any?
  end
end

