
$(function() {
  if ($('#board').length) {
    init();
  }
});

var init = function() {
  // Initialise the user
  var userId = $('main').attr('data-user-id');
  User.load(userId);

  // Initialise the board
  var promise = Board.load();
  promise.done(function(nodes, routes) {
    Renderer.render();
  });
  promise.fail(function(response) {
    // TODO: promise.fail
    console.error('fail');
    console.error(response);
  });

  // Initialise the game
  var gameId = $('main').attr('data-game-id');
  var promise = Game.load(gameId);
  promise.done(function() {
    Renderer.render();
  });
  promise.fail(function(response) {
    // TODO: promise.fail
    console.error('fail');
    console.error(response);
  });
};

