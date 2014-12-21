window.Renderer = new function() {
  this.render = function() {
    if (Board.loaded() && Game.loaded() && User.loaded()) {
      createSvg();

      createRoutes();
      createNodes();
      createPlayers();
      createNodeLabels();

      UiEvents.hook();
      ServerEvents.hook();

      this.refresh();
    }
  };

  this.refresh = function() {
    renderPlayers();
    renderPlayersPanel();
  };

  // PRIVATE

  var width = 1389;
  var height = 1130;

  var createSvg = function() {
    svg()
      .attr('viewBox', '0 0 ' + width + ' ' + height)
      .attr('preserveAspectRatio', 'xMidYMid meet');
  };

  var createRoutes = function() {
    svgRoutes()
      .data(Board.routes)
      .enter().append('line')
      .attr('class', function(route) { return 'route ' + route.transport_mode; })
      .attr('x1', function(route) { return Board.node(route.from_node_id).x * width; })
      .attr('y1', function(route) { return Board.node(route.from_node_id).y * height; })
      .attr('x2', function(route) { return Board.node(route.to_node_id).x * width; })
      .attr('y2', function(route) { return Board.node(route.to_node_id).y * height; });
  };

  var createNodes = function() {
    svgNodes()
      .data(Board.nodes)
      .enter().append('circle')
      .attr('class', function(node) { return 'node ' + node.transport_modes.join(' '); })
      .attr('r', 15)
      .attr('cx', function(node) { return node.x * width; })
      .attr('cy', function(node) { return node.y * height; })
      .attr('data-id', function(node) { return node.id; });
  };

  var createPlayers = function() {
    svgPlayers()
      .data(Game.players)
      .enter().append('circle')
      .attr('class', function(player) {
        return 'player ' +
          player.type.toLowerCase() +
          (Game.activePlayer && player.id === Game.activePlayer.id ? ' turn' : '') +
          (player.id === User.player().id ? ' me' : '');
      })
      .attr('r', 15)
      .attr('cx', function(player) { return Board.node(Game.player(player.id).current_node_id).x * width; } )
      .attr('cy', function(player) { return Board.node(Game.player(player.id).current_node_id).y * height; } )
      .attr('data-id', function(player) { return player.id; });
  };

  var createNodeLabels = function() {
    svgNodeLabels()
      .data(Board.nodes)
      .enter().append('text')
      .attr('class', 'node')
      .attr('text-anchor', 'middle')
      .attr('alignment-baseline', 'central')
      .text(function(node) { return node.id; } )
      .attr('x', function(node) { return node.x * width; })
      .attr('y', function(node) { return node.y * height; });
  };

  var renderPlayers = function() {
    // Move the players
    svgPlayers().transition().duration(150).ease('linear')
      .attr('cx', function(player) { return Board.node(Game.player(player.id).current_node_id).x * width; } )
      .attr('cy', function(player) { return Board.node(Game.player(player.id).current_node_id).y * height; } );

    // Clear all turn classes
    svgPlayers().filter('.turn').each(function(node) {
      Helpers.removeClass(d3.select(this), 'turn');
    });

    if (Game.activePlayer) {
      svgPlayers().each(function(player) {
        if (player.id === Game.activePlayer.id) {
          Helpers.addClass(d3.select(this), 'turn');
        }
      });
    }
  };

  var renderPlayersPanel = function() {
    Loaders.loadPlayersPanel('players', Game.id);
  };

  var svg = function() {
    return d3.select('#' + Board.id);
  };

  var svgRoutes = function() {
    return svg().selectAll('line.route');
  };

  var svgNodes = function() {
    return svg().selectAll('circle.node');
  };

  var svgPlayers = function() {
    return svg().selectAll('circle.player');
  };

  var svgNodeLabels = function() {
    return svg().selectAll('text.node');
  };
};

