Polymer('my-board', {
  created: function() {
    this.nodes = [];
    this.routes = [];

    this.players = [];
  },

  ready: function() {
    setInterval(function() {
      this.refresh();
    }.bind(this), 400);
  },

  refresh: function() {
    if (!Board.loaded() || !Game.loaded()) {
      Board.load();
      Game.refresh();
      return;
    }

    this.nodes = Board.nodes;
    this.routes = Board.routes;

    this.players = Game.players;
  },
});

