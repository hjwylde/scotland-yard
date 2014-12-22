window.Savers = (function(module) {
  module.savePlayerMove = function(gameId, playerId, data) {
    return $.post(Routes.game_player_moves_path(gameId, playerId, data));
  };

  return module;
})(window.Savers || {});

