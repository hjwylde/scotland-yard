module GamesHelper
  def number_of_spots_available(game:)
    pluralize(Game::NUMBER_OF_PLAYERS - game.players.length, 'spot')
  end

  def winner(game:)
    if DetectivesWonPolicy.new(game: game).won?
      'detectives'
    else
      'criminal'
    end
  end
end

