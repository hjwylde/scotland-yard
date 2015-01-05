window.Loaders = (function(module) {
  module.loadGamePlayerMoves = function(gameId, playerId) {
    return $.get(Routes.game_player_moves_path(gameId, playerId), null, null, 'json');
  };

  return module;
})(window.Loaders || {});

