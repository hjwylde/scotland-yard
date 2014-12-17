(function(hook) {
  ServerEvents.hook = function(force) {
    // Call the parent hook first
    hook();

    poll(force, 1000);
  };

  // PRIVATE

  var poll = function(force, timeout) {
    var promise = Loaders.loadCurrentRound(Game.id);
    promise.done(function(currentRound) {
      if (JSON.stringify(currentRound) !== JSON.stringify(Game.currentRound)) {
        Game.refresh().done(function() {
          if (Game.finished()) {
            location.href = Routes.game_path(Game.id)
          } else {
            Renderer.render();
            // TODO: Renderer.render should call force.start()
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
})(ServerEvents.hook);

