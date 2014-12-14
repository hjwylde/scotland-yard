class CriminalLostPolicy
  def initialize(game:)
    @game = game
  end

  # Policy for determining if the criminal has lost
  # This policy is synonymous to the detectives winning
  def lost?
    DetectivesWonPolicy.new(game: @game).won?
  end
end

