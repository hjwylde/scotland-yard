class DetectivesWonPolicy
  def initialize(game:)
    @game = game
  end

  # Policy for determining if the detectives have won
  # The detectives win if the criminal has lost on any of the rounds
  def won?
    @game.rounds.any? { |round| criminal_lost?(round) }
  end

  private

  def criminal_lost?(round)
    return false if round.moves.of_criminals.empty?

    criminal_node_id = round.moves.of_criminals.first.to_node_id

    detectives_node_ids = round.moves.of_detectives.pluck(:to_node_id)
    detectives_node_ids += round.previous.moves.of_detectives.pluck(:to_node_id) if round.previous

    detectives_node_ids.include?(criminal_node_id)
  end
end

