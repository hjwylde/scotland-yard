class PlayerTurnPolicy
  def initialize(game:, active_player: nil)
    @game, @active_player = game, active_player
  end

  # Policy for determining if it is a player's turn
  def turn_of?(player)
    @game.ongoing? && active_player == player
  end

  private

  def active_player
    @active_player || GetActivePlayerService.new(game: @game).call
  end
end

