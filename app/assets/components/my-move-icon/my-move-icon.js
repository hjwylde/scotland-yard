Polymer('my-move-icon', {
  nodeId: '?',

  onMouseOver: function() {
    if (this.nodeId === '?') {
      return;
    }

    Svg.nodes().filter('[data-id="' + this.nodeId + '"]').each(function(node) {
      d3.select(this).classed('highlighted', true);
    });
  },

  onMouseOut: function() {
    if (this.nodeId === '?') {
      return;
    }

    Svg.nodes().filter('[data-id="' + this.nodeId + '"]').each(function(node) {
      d3.select(this).classed('highlighted', false);
    });
  },
});

