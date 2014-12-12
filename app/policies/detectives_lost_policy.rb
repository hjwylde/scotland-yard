# Policy for determining if the detectives have lost
# The detectives lose provided:
# 1) the game has started,
# 2) they haven't won and,
# 3) none of them can move
class DetectivesLostPolicy
  def initialize(game:)
    @game = game
  end

  def lost?
    @game.started? && !detectives_won? && detectives_cannot_move?
  end

  private

  def detectives_won?
    DetectivesWonPolicy.new(game: @game).won?
  end

  def detectives_cannot_move?
    @game.detectives.none? do |detective|
      PlayerCanMovePolicy.new(player: detective).can_move?
    end
  end
end

