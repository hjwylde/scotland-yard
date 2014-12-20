window.Loaders = (function(module) {
  module.loadPlayers = function(gameId) {
    var request = $.get(Routes.game_players_path(gameId), null, null, 'json');

    request.then(function(players) {
      for (var i = 0; i < players.length; i++) {
        var player = players[i];

        player.index = i;
        player.current_node_index = Helpers.idToIndex(player.current_node_id);
      }
    });

    return request;
  };

  module.loadActivePlayer = function(gameId) {
    return $.get(Routes.game_players_active_path(gameId), null, null, 'json');
  };

  module.loadPlayersPanel = function(panelId, gameId) {
    return $('#' + panelId).load(Routes.game_players_path(gameId));
  };

  return module;
})(window.Loaders || {});

