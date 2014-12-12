window.ServerEvents = new function() {
  this.hook = function(force) {
    poll(force, 1000);
  };

  // PRIVATE

  var poll = function(force, timeout) {
    var promise = Loaders.loadCurrentRound(Game.id);
    promise.done(function(currentRound) {
      if (JSON.stringify(currentRound) !== JSON.stringify(Game.currentRound)) {
        Game.refresh().done(function() {
          if (Game.finished()) {
            window.location.href = Routes.game_path(Game.id)
          } else {
            Renderer.render();
            force.start();
          }
        });
      }
    });
    promise.always(function() {
      setTimeout(function() {
        poll(force, timeout);
      }, timeout)
    });
  };
};

