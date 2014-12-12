window.Loaders = new function() {
  this.loadBoard = function() {
    return $.when(this.loadNodes(), this.loadRoutes());
  };


  this.loadNodes = function() {
    var request = $.get(Routes.nodes_path());

    request.then(function(nodes) {
      nodes.forEach(function(node) {
        node.index = idToIndex(node.id);
        node.linked_node_indices = node.linked_node_ids.map(idToIndex);
      });

      return nodes;
    });

    return request;
  };

  this.loadRoutes = function() {
    var request = $.get(Routes.routes_path());

    request.then(function(routes) {
      routes.forEach(function(route) {
        route.from_node_index = idToIndex(route.from_node_id);
        route.to_node_index = idToIndex(route.to_node_id);

        route.source = route.from_node_index;
        route.target = route.to_node_index;
      });

      return routes;
    });

    return request;
  };

  this.loadGame = function(gameId) {
    return $.when(this.loadPlayers(gameId), this.loadCurrentRound(gameId));
  };

  this.loadPlayers = function(gameId) {
    var request = $.get(Routes.game_players_path(gameId));

    request.then(function(players) {
      for (var i = 0; i < players.length; i++) {
        var player = players[i];

        player.index = i;
        player.current_node_index = idToIndex(player.current_node_id);
      }
    });

    return request;
  };

  this.loadCurrentRound = function(gameId) {
    return $.get(Routes.game_rounds_current_path(gameId));
  };

  this.loadPlayersPanel = function(panelId, gameId) {
    return $('#' + panelId).load(Routes.game_players_path(gameId));
  };

  // PRIVATE

  var idToIndex = function(id) {
    return id - 1;
  };
};

