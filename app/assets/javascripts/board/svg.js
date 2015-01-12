window.Svg = {
  root: function() {
    return d3.select('#' + Board.id);
  },

  nodes: function() {
    return this.root().selectAll('circle.node');
  },

  nodeLabels: function() {
    return this.root().selectAll('text.node');
  },

  players: function() {
    return this.root().selectAll('circle.player');
  },

  routes: function() {
    return this.root().selectAll('line.route');
  },
};

