# Policy for determining if the detectives have won
# The detectives win if the criminal has lost on any of the rounds
class DetectivesWonPolicy
  def initialize(game:)
    @game = game
  end

  def won?
    @game.rounds.any?(&:criminal_lost?)
  end
end

