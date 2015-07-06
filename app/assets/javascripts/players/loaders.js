window.Loaders = (function(module) {
  module.loadGamePlayers = function(gameId) {
    var request = $.get(Routes.game_players_path(gameId), null, null, 'json');

    request.then(function(players) {
      // TODO: Enhance to a forEach loop?
      for (var i = 0; i < players.length; i++) {
        var player = players[i];

        player.isDetective = function() { return this.type === 'Detective'; };
        player.isCriminal = function() { return this.type === 'Criminal'; };

        player.isActive = function() { return this.id === Game.activePlayer.id; };

        player.moves = Game.players.length ? Game.player(player.id).moves : [];
        var promise = Loaders.loadGamePlayerMoves(Game.id, player.id);
        promise.done(function(moves) {
          this.moves = moves;
        }.bind(player));
      }
    });

    return request;
  };

  module.loadGamePlayersActive = function(gameId) {
    return $.get(Routes.game_players_active_path(gameId), null, null, 'json');
  };

  return module;
})(window.Loaders || {});

