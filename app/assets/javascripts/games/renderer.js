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
  };

  // PRIVATE

  var width = 1389;
  var height = 1130;

  var createSvg = function() {
    Svg.root()
      .attr('viewBox', '0 0 ' + width + ' ' + height)
      .attr('preserveAspectRatio', 'xMidYMid meet');
  };

  var createRoutes = function() {
    Svg.routes()
      .data(Board.routes)
      .enter().append('line')
      .attr('class', function(route) { return 'route ' + route.transport_mode; })
      .attr('x1', function(route) { return Board.node(route.from_node_id).x * width; })
      .attr('y1', function(route) { return Board.node(route.from_node_id).y * height; })
      .attr('x2', function(route) { return Board.node(route.to_node_id).x * width; })
      .attr('y2', function(route) { return Board.node(route.to_node_id).y * height; });
  };

  var createNodes = function() {
    Svg.nodes()
      .data(Board.nodes)
      .enter().append('circle')
      .attr('class', function(node) { return 'node ' + node.transport_modes.join(' '); })
      .attr('r', 15)
      .attr('cx', function(node) { return node.x * width; })
      .attr('cy', function(node) { return node.y * height; })
      .attr('data-id', function(node) { return node.id; });
  };

  var createPlayers = function() {
    Svg.players()
      .data(User.player().isCriminal() ? Game.players : Game.detectives())
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
    Svg.nodeLabels()
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
    Svg.players().transition().duration(150).ease('linear')
      .attr('cx', function(player) { return Board.node(Game.player(player.id).current_node_id).x * width; } )
      .attr('cy', function(player) { return Board.node(Game.player(player.id).current_node_id).y * height; } );

    // Clear all turn classes
    Svg.players().filter('.turn').each(function(node) {
      d3.select(this).classed('turn', false);
    });

    if (Game.activePlayer) {
      Svg.players().each(function(player) {
        if (player.id === Game.activePlayer.id) {
          d3.select(this).classed('turn', true);
        }
      });
    }
  };
};

