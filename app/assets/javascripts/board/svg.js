window.Svg = new function() {
  this.root = function() {
    return d3.select('#' + Board.id);
  };

  this.nodes = function() {
    return this.root().selectAll('circle.node');
  };

  this.nodeLabels = function() {
    return this.root().selectAll('text.node');
  };

  this.players = function() {
    return this.root().selectAll('circle.player');
  };

  this.routes = function() {
    return this.root().selectAll('line.route');
  };
};

