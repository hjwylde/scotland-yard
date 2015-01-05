(function(hook) {
  ServerEvents.hook = function() {
    // Call the parent hook first
    hook();

    poll(1000);
  };

  // PRIVATE

  var poll = function(timeout) {
    var promise = Loaders.loadGameRoundsCurrent(Game.id);
    promise.done(function(currentRound) {
      if (JSON.stringify(currentRound) !== JSON.stringify(Game.currentRound)) {
        Game.refresh().done(function() {
          if (Game.finished()) {
            location.href = Routes.game_path(Game.id)
          } else {
            Renderer.refresh();
          }
        });
      }
    });
    promise.always(function() {
      setTimeout(function() {
        poll(timeout);
      }, timeout)
    });
  };
})(ServerEvents.hook);

