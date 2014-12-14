class CriminalWonPolicy
  def initialize(game:)
    @game = game
  end

  # Policy for determining if the criminal has won
  # This policy is synonymous to the detectives losing
  def won?
    DetectivesLostPolicy.new(game: @game).lost?
  end
end

