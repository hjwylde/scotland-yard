class GetActivePlayerService
  def initialize(game:)
    @game = game
  end

  # Service for retrieving the active player
  # The active player is the one who's turn it is
  # To begin, it may only be a player's turn if the game is on-going
  # The players are ordered naturally by first type (such that the criminal moves first) and then id
  # A player is only considered in the to-move queue if they haven't moved yet and they can move
  def call
    ticket_counts = CountPlayerTicketsService.new(game: @game).call

    unmoved_players.detect { |player| player_can_move?(player, ticket_counts) } if @game.ongoing?
  end

  private

  def unmoved_players
    @game.players - @game.current_round.players
  end

  def player_can_move?(player, ticket_counts)
    PlayerCanMovePolicy.new(player: player, cache: { ticket_counts: ticket_counts }).can_move?
  end
end

