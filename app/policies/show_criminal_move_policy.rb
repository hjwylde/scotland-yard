# Policy for determining whether a criminal's move should be shown to the detectives
# The standard game shows the moves on #3, #8, #13 and #18
# This policy abstracts this and says a move should be shown on every 5th move after the 3rd
class ShowCriminalMovePolicy
  def initialize(move:)
    @move = move
  end

  def show?
    (@move.round.number - 3) % 5 == 0
  end
end

