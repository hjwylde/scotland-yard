class Detective < Player
  STARTING_TICKET_COUNTS = { taxi: 10, bus: 8, underground: 4, black: 0, double_move: 0 }

  def starting_ticket_counts
    STARTING_TICKET_COUNTS
  end
end

