$(function() {
  if ($('template#game').length) {
    Game.id = $('template#game').data('game-id');
  }
});

