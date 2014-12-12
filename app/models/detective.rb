class Detective < Player
  STARTING_TICKETS_COUNT = { taxi: 10, bus: 8, underground: 4, black: 0, double_move: 0 }

  def starting_tickets_count
    STARTING_TICKETS_COUNT
  end
end

