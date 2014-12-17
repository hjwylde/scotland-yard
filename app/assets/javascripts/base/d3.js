// TODO: Remove this
window.D3 = new function() {
  this.createForce = function(options) {
    if (options === void(0)) options = {};

    if (options.width === void(0)) options.width = 1400;
    if (options.height === void(0)) options.height = 1400;
    if (options.gutter === void(0)) options.gutter = 0;

    if (options.charge === void(0)) options.charge = -250;
    if (options.gravity === void(0)) options.gravity = 0.02;
    if (options.friction === void(0)) options.friction = 0.9;

    if (options.linkDistance === void(0)) options.linkDistance = forceLinkDistance;
    if (options.linkStrength === void(0)) options.linkStrength = forceLinkStrength;

    if (options.animationStep === void(0)) options.animationStep = 40;
    if (options.tick === void(0)) options.tick = forceTick(options);

    var force = d3.layout.force()
      .nodes(Board.nodes)
      .links(Board.routes)
      .size([options.width, options.height])

      .charge(options.charge)
      .gravity(options.gravity)
      .friction(options.friction)

      .linkDistance(options.linkDistance)
      .linkStrength(options.linkStrength)

      .on('tick', options.tick);

    fixSvgNodes(options);

    return force;
  };

  // PRIVATE

  var fixSvgNodes = function(options) {
    Board.nodes.forEach(function(node) {
      if (node.fixed) {
        node.x = node.x * options.width;
        node.y = node.y * options.height;
      }
    });
  };


  var forceTick = function(options) {
    return function() {
      var svg = d3.select('#' + Board.id);
      var svgNodes = svg.selectAll('circle.node');
      var svgNodeLabels = svg.selectAll('text.node');
      var svgLinks = svg.selectAll('line.link');
      var svgPlayers = svg.selectAll('circle.player');

      svgNodes.transition().ease('linear').duration(options.animationStep)
        .attr('cx', function(node) { return Math.clamp(options.gutter, node.x, options.width - options.gutter); })
        .attr('cy', function(node) { return Math.clamp(options.gutter, node.y, options.height - options.gutter); });

      svgNodeLabels.transition().ease('linear').duration(options.animationStep)
        .attr('x', function(node) { return Math.clamp(options.gutter, node.x, options.width - options.gutter); })
        .attr('y', function(node) { return Math.clamp(options.gutter, node.y, options.height - options.gutter); });

      svgLinks.transition().ease('linear').duration(options.animationStep)
        .attr('x1', function(link) { return Math.clamp(options.gutter, link.source.x, options.width - options.gutter); })
        .attr('y1', function(link) { return Math.clamp(options.gutter, link.source.y, options.height - options.gutter); })
        .attr('x2', function(link) { return Math.clamp(options.gutter, link.target.x, options.width - options.gutter); })
        .attr('y2', function(link) { return Math.clamp(options.gutter, link.target.y, options.height - options.gutter); });

      svgPlayers.transition().ease('linear').duration(options.animationStep)
        .attr('cx', function(player) { return Board.node(Game.player(player.id).current_node_id).x; } )
        .attr('cy', function(player) { return Board.node(Game.player(player.id).current_node_id).y; } );
    };
  };

  var forceLinkDistance = function(link) {
    baseDistance = 10;

    switch(link.transport_mode) {
    case 'taxi':
      return baseDistance;
    case 'bus':
      return baseDistance * 3;
    case 'underground':
      return baseDistance * 5;
    case 'boat':
      return baseDistance * 6;
    }
  };

  var forceLinkStrength = function(link) {
    baseStrength = 0.8;

    switch(link.transport_mode) {
    case 'taxi':
      return baseStrength;
    case 'bus':
    case 'boat':
      return baseStrength * 0.8;
    case 'underground':
      return baseStrength * 0.6;
    }
  };
};

