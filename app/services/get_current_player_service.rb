class GetCurrentPlayerService
  def initialize(game: game)
    @game = game
  end

  # Finds the player who's turn it is in the given game
  # Returns nil if the game is not on-going, otherwise returns a single player
  def call
    return unless @game.ongoing?

    policy = PlayerTurnPolicy.new(round: @game.current_round)
    @game.players.detect { |player| policy.turn_of?(player) }
  end
end

