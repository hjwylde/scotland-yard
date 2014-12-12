class Criminal < Player
  STARTING_TICKETS_COUNT = { taxi: 4, bus: 3, underground: 3, black: 4, double_move: 2 }

  def starting_tickets_count
    STARTING_TICKETS_COUNT
  end
end
