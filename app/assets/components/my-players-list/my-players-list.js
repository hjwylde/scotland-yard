Polymer('my-players-list', {
  created: function() {
    this.players = [];
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

    this.players = Game.players;
  },
});

