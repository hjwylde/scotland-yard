window.Savers = new function() {
  this.savePlayerMove = function(gameId, playerId, data) {
    return $.post(Routes.game_player_moves_path(gameId, playerId, data));
  };
};

