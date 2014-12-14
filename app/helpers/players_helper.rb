module PlayersHelper
  def player_classes(player:)
    ['player', player.type.downcase, ('turn' if player.id == @current_player.id)].compact
  end

  def show_player_ticket_counts(player:)
    ticket_counts = CountPlayerTicketsService.new(player: player).call

    if player.detective?
      [:black, :double_move].each { |ticket| ticket_counts.delete(ticket) }
    end

    # TODO: Temporary deleting double move
    ticket_counts.delete(:double_move)

    ticket_counts.reduce('') do |html, (ticket, count)|
      html + (content_tag :div, count, class: [:ticket, ticket])
    end.html_safe
  end

  def show_player_moves(player:)
    player.moves.reduce('') do |html, move|
      html + show_player_move(move: move)
    end.html_safe
  end

  def show_player_current_node(player:)
    if player.detective?
      content_tag :div, player.current_node.id, class: [:'current-node']
    else
      ''
    end
  end

  private

  def show_player_move(move:)
    if move.player.detective? || ShowCriminalMovePolicy.new(move: move).show?
      content_tag :div, move.to_node_id, class: [:move, move.ticket]
    else
      content_tag :div, ' ', class: [:move, move.ticket]
    end
  end
end

