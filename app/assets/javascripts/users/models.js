window.User = new function() {
  this.id = -1;
  this.name = null;

  this.playerIds = [];
  this.playerIndices = [];

  // Flag for whether the player wishes to make a double move
  this.doubleMove = false;

  // Gets the user's player that is in this game
  this.player = function() {
    return Game.players.filter((function(player) {
      return $.inArray(player.id, this.playerIds) >= 0;
    }).bind(this))[0];
  };

  this.toggleDoubleMove = function() {
    this.doubleMove = !this.doubleMove;

    // Client-side validation that the player can use a double move token
    if (this.player().token_counts['double_move'] <= 0 || this.player().type != 'Criminal') {
      this.doubleMove = false;
    }

    return this.doubleMove;
  };

  this.load = function() {
    var promise = Loaders.loadUser()
    promise.done((function(user) {
      this.id = user.id;
      this.name = user.name;
      this.playerIds = user.player_ids;
      this.playerIndices = user.player_indices;
    }).bind(this));

    return promise;
  };

  this.loaded = function() {
    return this.id >= 0;
  };
};

