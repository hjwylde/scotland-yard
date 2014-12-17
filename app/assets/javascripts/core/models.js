window.User = new function() {
  this.id = -1;
  this.name = null;
  this.playerIds = [];
  this.playerIndices = [];
  this.doubleMove = false;

  this.player = function() {
    return Game.players.filter(function(player) {
      return $.inArray(player.id, User.playerIds) >= 0;
    })[0];
  };

  this.toggleDoubleMove = function() {
    this.doubleMove = !this.doubleMove;

    // Client-side validation that the player can use a double move ticket
    if (this.player().ticket_counts['double-move'] <= 0 || this.player().type != 'Criminal') {
      this.doubleMove = false;
    }

    return this.doubleMove;
  };

  this.load = function() {
    var promise = Loaders.loadUser()
    promise.done(function(user) {
      User.id = user.id;
      User.name = user.name;
      User.playerIds = user.player_ids;
      User.playerIndices = user.player_indices;
    });

    return promise;
  };

  this.loaded = function() {
    return this.id >= 0;
  };
};

window.Board = new function() {
  this.id = 'board';

  this.nodes = [];
  this.routes = [];

  this.node = function(id) {
    return this.nodes.filter(function(node) {
      return node.id == id;
    })[0];
  };

  this.findRoutes = function(fromNodeId, toNodeId) {
    return this.routes.filter(function(route) {
      return route.from_node_id == fromNodeId && route.to_node_id == toNodeId;
    });
  };

  this.load = function() {
    var promise = Loaders.loadBoard();
    promise.done(function(nodes, routes) {
      Board.nodes = nodes[0];
      Board.routes = routes[0];
    });

    return promise;
  }

  this.loaded = function() {
    return this.nodes.length > 0 && this.routes.length > 0;
  };
};

window.Game = new function() {
  this.id = -1;

  this.players = [];
  this.currentRound = null;

  this.finished = function() {
    return this.players.filter(function(player) {
      return player.players_turn;
    }).length == 0;
  };

  // The player who's turn it is currently
  this.currentPlayer = function() {
    return this.players.filter(function(player) {
      return player.players_turn;
    })[0];
  };

  this.player = function(id) {
    return this.players.filter(function(player) {
      return player.id == id;
    })[0];
  };

  this.load = function(gameId) {
    this.id = gameId;

    var promise = Loaders.loadGame(gameId);
    promise.done(function(players, currentRound) {
      Game.players = players[0];
      Game.currentRound = currentRound[0];
    });

    return promise;
  };

  this.refresh = function() {
    return this.load(this.id);
  };

  this.loaded = function() {
    return this.id >= 0 && this.players.length > 0 && this.currentRound != null;
  };
};

