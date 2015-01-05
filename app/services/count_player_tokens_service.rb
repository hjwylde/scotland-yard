class CountPlayerTokensService
  def initialize(game:)
    @game = game
  end

  def call
    token_counts = Hash.new do |hash, player_id|
      hash[player_id] = @game.players.find(player_id).starting_token_counts
    end

    used_double_move_token_counts.each do |player_id, count|
      token_counts[player_id][:double_move] -= count
    end

    token_counts
  end

  private

  def used_double_move_token_counts
    # Double move tokens are counted by the rounds with only a single player in them
    moves = @game.moves.double.select { |move| move.round.finished? }

    Hash[moves.group_by(&:player_id).map { |player_id, moves| [player_id, moves.length] }]
  end
end

