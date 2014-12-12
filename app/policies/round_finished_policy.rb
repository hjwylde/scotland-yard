# Policy for determining if a round is finished
# A round is finished if either:
# 1) the game has finished or,
# 2) every player that can move has moved
class RoundFinishedPolicy
  def initialize(round:)
    @round = round
  end

  def finished?
    @round.game.finished? || (unmoved_players & movable_players).none?
  end

  private

  def unmoved_players
    @round.game.players - @round.players
  end

  def movable_players
    @round.game.players.select { |player| player_can_move?(player) }
  end

  def player_can_move?(player)
    PlayerCanMovePolicy.new(player: player).can_move?
  end
end

