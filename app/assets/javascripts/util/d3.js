window.D3 = new function() {
  this.createForce = function(options) {
    if (typeof options === 'undefined') options = {};

    if (typeof options.width === 'undefined') options.width = 1400;
    if (typeof options.height === 'undefined') options.height = 1400;
    if (typeof options.gutter === 'undefined') options.gutter = 0;

    if (typeof options.charge === 'undefined') options.charge = -250;
    if (typeof options.gravity === 'undefined') options.gravity = 0.02;
    if (typeof options.friction === 'undefined') options.friction = 0.9;

    if (typeof options.linkDistance === 'undefined') options.linkDistance = forceLinkDistance;
    if (typeof options.linkStrength === 'undefined') options.linkStrength = forceLinkStrength;


    if (typeof options.animationStep === 'undefined') options.animationStep = 40;
    if (typeof options.tick === 'undefined') options.tick = forceTick(options);

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

