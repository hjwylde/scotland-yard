class Criminal < Player
  STARTING_TICKET_COUNTS = { taxi: 4, bus: 3, underground: 3, black: 4 }
  STARTING_TOKEN_COUNTS = { double_move: 2 }

  def starting_ticket_counts
    STARTING_TICKET_COUNTS.clone
  end

  def starting_token_counts
    STARTING_TOKEN_COUNTS.clone
  end
end

