window.Renderer = new function() {
  this.render = function() {
    if (!Board.loaded() || !Game.loaded() || !User.loaded()) {
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
    if (typeof options === 'undefined') options = {};

    if (typeof options.width === 'undefined') options.width = 1400;
    if (typeof options.height === 'undefined') options.height = 1400;

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
      .attr('class', function(player) { return 'player ' + player.type.toLowerCase() + (player.players_turn ? ' turn' : '') + (player.id == User.id ? ' me' : ''); })
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
    // Clear all turn and adjacent classes
    svgPlayers().filter('.turn').each(function(node) {
      Svg.removeClass(d3.select(this), 'turn');
    });
    svgNodes().filter('.adjacent').each(function(node) {
      Svg.removeClass(d3.select(this), 'adjacent');
    });

    var userPlayer = User.player();
    // If it's the user's turn, then highlight adjacent nodes
    // TODO: Highlight the routes as well?
    if (userPlayer.players_turn) {
      var currentNode = Board.node(userPlayer.current_node_id);
      svgNodes().each(function(node) {
        if ($.inArray(node.id, currentNode.linked_node_ids) >= 0) {
          Svg.addClass(d3.select(this), 'adjacent');
        }
      });
    }

    var currentPlayer = Game.currentPlayer();
    if (currentPlayer) {
      svgPlayers().each(function(player) {
        if (player.id == currentPlayer.id) {
          Svg.addClass(d3.select(this), 'turn');
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

