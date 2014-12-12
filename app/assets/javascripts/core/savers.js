window.Savers = new function() {
  this.savePlayerMove = function(playerId, data) {
    return $.post(Routes.player_moves_path(playerId, data));
  };
};

