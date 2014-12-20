window.Renderer = new function() {
  this.render = function() {
    if (!User.loaded() || !Board.loaded() || !Game.loaded()) {
      return;
    }

    if (firstRender) {
      firstRender = false;

      var width = 1389;
      var height = 1130;
      var gutter = 20;

      // Render the board SVG first
      renderSvg({ width: width, height: height });

      // Set up and start the force directed graph to lay out the board
      var force = D3.createForce({ width: width, height: height, gutter: gutter });
      force.start();

      // Add some UI events to the board
      UiEvents.hook(force);
      ServerEvents.hook(force);
    }

    renderPlayers();
    renderPlayersPanel();
  };

  // PRIVATE

  var firstRender = true;

  var renderSvg = function(options) {
    if (options === void(0)) options = {};

    if (options.width === void(0)) options.width = 1400;
    if (options.height === void(0)) options.height = 1400;

    var svg = d3.select('#' + Board.id)
      .attr('viewBox', '0 0 ' + options.width + ' ' + options.height)
      .attr('preserveAspectRatio', 'xMidYMid meet');

    var svgLinks = svg.selectAll('line');
    var svgNodes = svg.selectAll('circle');
    var svgPlayers = svg.selectAll('circle');
    var svgNodeLabels = svg.selectAll('circle');

    // Set up the links
    svgLinks
      .data(Board.routes)
      .enter().append('line')
      .attr('class', function(link) { return 'link ' + link.transport_mode; });

    // Set up the nodes
    svgNodes
      .data(Board.nodes)
      .enter().append('circle')
      .attr('class', function(node) { return 'node ' + node.transport_modes.join(' '); })
      .attr('r', 15)
      .attr('data-id', function(node) { return node.id; })
      .attr('data-index', function(node) { return node.index; });

    // Set up the players
    svgPlayers
      .data(Game.players)
      .enter().append('circle')
      .attr('class', function(player) { return 'player ' + player.type.toLowerCase() + (Game.activePlayer && player.id === Game.activePlayer.id ? ' turn' : '') + (player.id === User.player().id ? ' me' : ''); })
      .attr('r', 15)
      .attr('data-id', function(player) { return player.id; });

    // Set up the node labels
    svgNodeLabels
      .data(Board.nodes)
      .enter().append('text')
      .attr('class', 'node')
      .attr('text-anchor', 'middle')
      .attr('alignment-baseline', 'central')
      .text(function(node) { return node.id; } );
  };

  var renderPlayers = function() {
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

  var svgNodes = function() {
    return svg().selectAll('circle.node');
  };

  var svgPlayers = function() {
    return svg().selectAll('circle.player');
  };
};

