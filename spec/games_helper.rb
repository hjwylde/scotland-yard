module GamesHelper
  attr_reader :game, :current_player

  def load_game(game = nil)
    @game = game || instance_double(Game, id: 0)

    allow(Game).to receive(:find).with(@game.id).and_return @game
    allow(Game).to receive(:preload).and_return Game
  end

  def load_current_player(current_player = nil)
    @current_player = current_player || instance_double(Player, id: 0)

    players = double
    allow(players).to receive(:find_by).with(user_id: current_user.id).and_return @current_player

    allow(game).to receive(:players).and_return players
    allow(current_user).to receive(:players).and_return players
  end
end

