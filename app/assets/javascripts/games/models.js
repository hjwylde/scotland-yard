window.Game = new function() {
  this.id = -1;

  this.players = [];
  this.currentRound = null;

  this.finished = function() {
    // TODO: Use a status flag to check
    return false;
  };

  // The player who's turn it is currently
  this.currentPlayer = function() {
    return this.players.filter(function(player) {
      return player.players_turn;
    })[0];
  };

  this.player = function(id) {
    return this.players.filter(function(player) {
      return player.id === id;
    })[0];
  };

  this.load = function(gameId) {
    this.id = gameId;

    var promise = Loaders.loadGame(gameId);
    promise.done((function(players, currentRound) {
      this.players = players[0];
      this.currentRound = currentRound[0];
    }).bind(this));

    return promise;
  };

  this.refresh = function() {
    var promise = this.load(this.id);

    promise.done((function() {
      if (this.activePlayer && this.activePlayer.id === User.player().id) {
        Helpers.createTurnNotification();
      }
    });

    return promise;
  };

  this.loaded = function() {
    return this.id >= 0 && this.players.length && this.currentRound;
  };
};

window.Board = new function() {
  this.id = 'board';

  this.nodes = [];
  this.routes = [];

  this.node = function(id) {
    return this.nodes[Helpers.idToIndex(id)];
  };

  this.findRoutes = function(fromNodeId, toNodeId) {
    return this.routes.filter(function(route) {
      return route.from_node_id === Math.min(fromNodeId, toNodeId) && route.to_node_id === Math.max(fromNodeId, toNodeId);
    });
  };

  this.load = function() {
    var promise = Loaders.loadBoard();
    promise.done((function(nodes, routes) {
      this.nodes = nodes[0];
      this.routes = routes[0];
    }).bind(this));

    return promise;
  }

  this.loaded = function() {
    return this.nodes.length && this.routes.length;
  };
};

