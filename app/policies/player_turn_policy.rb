class PlayerTurnPolicy
  def initialize(round:)
    @round = round
  end

  # Policy for determining if it is a player's turn
  # To begin, it may only be a player's turn if the game is on-going
  # The players are ordered naturally by first type (such that the criminal moves first) and then id
  # A player is only considered in the to-move queue if they haven't moved yet and they can move
  # It is any given player's turn if they are at the front of that queue
  def turn_of?(player)
    @round.game.ongoing? && next_player_to_move == player
  end

  private

  def player_can_move?(player)
    PlayerCanMovePolicy.new(player: player).can_move?
  end

  def next_player_to_move
    moved_players = @round.players

    @round.game.players.ordered.detect do |player|
      moved_players.exclude?(player) && player_can_move?(player)
    end
  end
end

