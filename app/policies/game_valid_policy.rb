class GameValidPolicy
  include Wisper::Publisher

  def initialize(game:)
    @game = game

    @errors = []
  end

  # Policy for determining if the game is valid
  # The game is valid provided:
  # 1) the game only ever has at most 1 criminal,
  # 2) the game only ever has at most Game::NUMBER_OF_PLAYERS and,
  # 3) if the game has Game::NUMBER_OF_PLAYERS, then the game has exactly 1 criminal
  def valid?
    check_player_count_is_valid
    check_player_types_are_valid

    publish(:fail, @errors) if @errors.any?

    @errors.empty?
  end

  private

  def check_player_count_is_valid
    if @game.players.length > Game::NUMBER_OF_PLAYERS
      @errors << "Game must have #{Game::NUMBER_OF_PLAYERS} or less players"
    end
  end

  def check_player_types_are_valid
    unless player_types_are_valid
      @errors << 'Game may only have 1 criminal'
    end
  end

  def player_types_are_valid
    if @game.players.length < Game::NUMBER_OF_PLAYERS
      !@game.players.many?(&:criminal?)
    else
      @game.players.one?(&:criminal?)
    end
  end
end

