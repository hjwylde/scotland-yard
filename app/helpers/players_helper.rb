module PlayersHelper
  def player_classes(player:)
    ['player', player.type.downcase, ('turn' if player == @active_player), ('me' if player == @current_player)].compact
  end

  def show_player_ticket_counts(player:, ticket_counts:)
    ticket_counts.select do |ticket, count|
      player.criminal? || ticket != :black
    end.reduce('') do |html, (ticket, count)|
      html + (content_tag :div, count, class: [:ticket, ticket.to_s.gsub(/_/, '-')])
    end.html_safe
  end

  def show_player_token_counts(player:, token_counts:)
    token_counts.select do |token, count|
      player.criminal?
    end.reduce('') do |html, (token, count)|
      html + (content_tag :div, count, class: [:token, token.to_s.gsub(/_/, '-')])
    end.html_safe
  end

  def show_player_moves(player:)
    player.moves.reduce('') do |html, move|
      html + show_player_move(move: move)
    end.html_safe
  end

  def show_player_current_node(player:)
    if player.detective?
      content_tag :div, player.current_node_id, class: [:'current-node']
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

