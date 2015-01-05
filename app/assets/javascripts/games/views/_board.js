(function() {
  $(function() {
    if ($('#board').length) {
      init();
    }
  });

  var init = function() {
    loadUser(4000);
    loadBoard(4000);
    loadGame(4000);
  };

  var loadUser = function(timeout) {
    var promise = User.load();
    promise.done(function(user) {
      Renderer.render();
    });
    promise.fail(function(response) {
      console.error('fail');
      console.error(response);

      Toast.error('Unable to load user information, retrying in ' + (timeout / 1000) + ' seconds...');

      setTimeout(function() {
        loadUser(Math.min(timeout * 2, 32000));
      }, timeout);
    });
  };

  var loadBoard = function(timeout) {
    var promise = Board.load();
    promise.done(function(nodes, routes) {
      Renderer.render();
    });
    promise.fail(function(response) {
      console.error('fail');
      console.error(response);

      Toast.error('Unable to load board information, retrying in ' + (timeout / 1000) + ' seconds...');

      setTimeout(function() {
        loadBoard(Math.min(timeout * 2, 32000));
      }, timeout);
    });
  };

  var loadGame = function(timeout) {
    var gameId = $('main').attr('data-game-id');
    var promise = Game.load(gameId);
    promise.done(function() {
      Renderer.render();
    });
    promise.fail(function(response) {
      console.error('fail');
      console.error(response);

      Toast.error('Unable to load game information, retrying in ' + (timeout / 1000) + ' seconds...');

      setTimeout(function() {
        loadGame(Math.min(timeout * 2, 32000));
      }, timeout);
    });
  };
})();

