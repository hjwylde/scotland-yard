class RoundFinishedPolicy
  def initialize(round:)
    @round = round
  end

  # Policy for determining if a round is finished
  # A round is finished if either:
  # 1) the game has finished or,
  # 2) every player that can move has moved
  def finished?
    @round.game.finished? || (unmoved_players & movable_players).none?
  end

  private

  def unmoved_players
    @round.game.players - @round.players
  end

  def movable_players
    ticket_counts = CountPlayerTicketsService.new(game: @round.game).call

    @round.game.players.select do |player|
      PlayerCanMovePolicy.new(player: player, cache: { ticket_counts: ticket_counts }).can_move?
    end
  end
end

