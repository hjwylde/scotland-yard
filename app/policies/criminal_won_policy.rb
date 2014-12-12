# Policy for determining if the criminal has won
# This policy is synonymous to the detectives losing
class CriminalWonPolicy
  def initialize(game:)
    @game = game
  end

  def won?
    DetectivesLostPolicy.new(game: @game).lost?
  end
end

