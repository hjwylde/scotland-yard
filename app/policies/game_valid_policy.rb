class GameValidPolicy
  def initialize(game:)
    @game = game
  end

  # Policy for determining if the game is valid
  # The game is valid provided:
  # 1) the game only ever has at most 1 criminal,
  # 2) the game only ever has at most Game::NUMBER_OF_PLAYERS and,
  # 3) if the game has Game::NUMBER_OF_PLAYERS, then the game has exactly 1 criminal
  def valid?
    player_count_is_valid && player_types_are_valid
  end

  private

  def player_count_is_valid
    @game.players.length <= Game::NUMBER_OF_PLAYERS
  end

  def player_types_are_valid
    if @game.players.length < Game::NUMBER_OF_PLAYERS
      !@game.players.many?(&:criminal?)
    else
      @game.players.one?(&:criminal?)
    end
  end
end

