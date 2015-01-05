window.Loaders = (function(module) {
  module.loadGames = function() {
    return $.get(Routes.games_path(), null, null, 'json');
  };

  module.loadGame = function(gameId) {
    return $.get(Routes.game_path(gameId), null, null, 'json');
  };

  module.loadGameRoundsCurrent = function(gameId) {
    return $.get(Routes.game_rounds_current_path(gameId), null, null, 'json');
  };

  return module;
})(window.Loaders || {});

