module UsersHelper
  def player(game:, user:)
    return (game.players & user.players).first
  end
end

