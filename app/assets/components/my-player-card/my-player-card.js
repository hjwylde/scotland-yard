Polymer('my-player-card', {
  playerId: 0,

  created: function() {
    this.player = {};
  },

  ready: function() {
    this.refresh();

    setInterval(function() {
      this.refresh();
    }.bind(this), 400);
  },

  refresh: function() {
    if (!Game.loaded()) {
      return;
    }

    this.player = Game.player(this.playerId);
  },

  onMouseOver: function() {
    if (this.player.isCriminal()) {
      return;
    }

    Svg.players().filter('[data-id="' + this.playerId + '"]').each(function(node) {
      d3.select(this).classed('highlighted', true);
    });
  },

  onMouseOut: function() {
    if (this.player.isCriminal()) {
      return;
    }

    Svg.players().filter('[data-id="' + this.playerId + '"]').each(function(node) {
      d3.select(this).classed('highlighted', false);
    });
  },
});

