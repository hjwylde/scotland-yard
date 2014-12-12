# Policy for determining if the game has finished
# The game has finished if either the detectives or criminal have won
class GameFinishedPolicy
  def initialize(game:)
    @game = game
  end

  def finished?
    detectives_won? || criminal_won?
  end

  private

  def detectives_won?
    DetectivesWonPolicy.new(game: @game).won?
  end

  def criminal_won?
    CriminalWonPolicy.new(game: @game).won?
  end
end

