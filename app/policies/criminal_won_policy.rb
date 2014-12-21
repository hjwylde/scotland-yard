class CriminalWonPolicy
  def initialize(game:)
    @game = game
  end

  # Policy for determining if the criminal has won
  # The criminal wins provided:
  # 1) the game has started,
  # 2) the detectives haven't won and,
  # 3) no detective can move
  def won?
    @game.started? && !detectives_won? && detectives_cannot_move?
  end

  private

  def detectives_won?
    DetectivesWonPolicy.new(game: @game).won?
  end

  def detectives_cannot_move?
    ticket_counts = CountPlayerTicketsService.new(game: @game).call

    @game.detectives.none? do |detective|
      PlayerCanMovePolicy.new(player: detective, cache: { ticket_counts: ticket_counts }).can_move?
    end
  end
end

