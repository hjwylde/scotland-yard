window.Game = new function() {
  this.id = -1;

  this.players = [];
  this.activePlayer = null;
  this.currentRound = null;

  this.status = null;

  this.finished = function() {
    return this.status === 'finished';
  };

  this.detectives = function() {
    return this.players.filter(function(player) {
      return player.isDetective();
    });
  };

  this.player = function(id) {
    return this.players.filter(function(player) {
      return player.id === id;
    })[0];
  };

  this.load = function(gameId) {
    this.id = gameId;

    var promise = $.when(Loaders.loadGame(gameId), Loaders.loadGamePlayers(gameId), Loaders.loadGamePlayersActive(gameId), Loaders.loadGameRoundsCurrent(gameId));
    promise.done(function(game, players, activePlayer, currentRound) {
      this.status = game[0].status;
      this.players = players[0];
      this.activePlayer = this.player(activePlayer[0].id);
      this.currentRound = currentRound[0];
    }.bind(this));

    return promise;
  };

  this.refresh = function() {
    var promise = this.load(this.id);

    promise.done(function() {
      if (this.activePlayer && this.activePlayer.id === User.player().id) {
        Helpers.createTurnNotification();
        Toast.info("It's your turn");
      }
    }.bind(this));

    return promise;
  };

  this.loaded = function() {
    return this.id >= 0 && this.players.length && this.currentRound;
  };
};

