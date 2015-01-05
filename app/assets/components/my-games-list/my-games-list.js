Polymer('my-games-list', {
  created: function() {
    this.games = [];
  },

  ready: function() {
    this.refresh();

    setInterval(function() {
      this.refresh();
    }.bind(this), 2000);
  },

  refresh: function() {
    var promise = Loaders.loadGames();

    promise.done(function(games) {
      this.games = games.filter(function(game) {
        return game.status === this.status;
      }.bind(this));
    }.bind(this));

    return promise;
  },

  onTap: function(e, detail) {
    // TODO: Load the game in the current window
    window.location.href = Routes.game_path(detail.data.id);
  },
});

