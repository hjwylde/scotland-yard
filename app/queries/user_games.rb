class UserGames
  def initialize(user:)
    @user = user
  end

  # Gets all games the user is either playing in or may join
  def call
    Game.preload(:players, :rounds).reverse.reject do |game|
      game.finished? || (game.ongoing? && @user.games.exclude?(game))
    end
  end
end

