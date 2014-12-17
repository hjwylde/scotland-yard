window.Loaders = (function(module) {
  module.loadBoard = function() {
    return $.when(this.loadNodes(), this.loadRoutes());
  };

  module.loadGame = function(gameId) {
    return $.when(this.loadPlayers(gameId), this.loadCurrentRound(gameId));
  };

  module.loadCurrentRound = function(gameId) {
    return $.get(Routes.game_rounds_current_path(gameId));
  };

  return module;
})(window.Loaders || {});

