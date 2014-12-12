module GamesHelper
  def winner(game:)
    if DetectivesWonPolicy.new(game: game).won?
      'detectives'
    else
      'criminal'
    end
  end
end

