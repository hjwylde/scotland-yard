(function(hook) {
  UiEvents.hook = function(force) {
    // Call parent hook first
    hook(force);

    onMoveMouseEnter();
    onMoveMouseLeave();
    onCurrentNodeMouseEnter();
    onCurrentNodeMouseLeave();
    onDoubleMoveClick();
  };

  // PRIVATE

  var onMoveMouseEnter = function() {
    // Highlight the node on the board when the user hovers over a player move
    $('#players').on('mouseenter', 'div.move:not(.hide)', function() {
      var id = $(this).text();

      svg().select('circle.node[data-id="' + id + '"]').each(function(node) {
        Helpers.addClass(d3.select(this), 'highlighted');
      });
    });
  };

  var onMoveMouseLeave = function() {
    $('#players').on('mouseleave', 'div.move:not(.hide)', function() {
      var id = $(this).text();

      svg().select('circle.node[data-id="' + id + '"]').each(function(node) {
        Helpers.removeClass(d3.select(this), 'highlighted');
      });
    });
  };

  var onCurrentNodeMouseEnter = function() {
    // Highlight the node on the board when the user hovers over a player current node
    $('#players').on('mouseenter', 'div.current-node', function() {
      var id = $(this).parent().closest('div.player').attr('data-id');

      svg().select('circle.player[data-id="' + id + '"]').each(function(node) {
        Helpers.addClass(d3.select(this), 'highlighted');
      });
    });
  };

  var onCurrentNodeMouseLeave = function() {
    $('#players').on('mouseleave', 'div.current-node', function() {
      var id = $(this).parent().closest('div.player').attr('data-id');

      svg().select('circle.player[data-id="' + id + '"]').each(function(node) {
        Helpers.removeClass(d3.select(this), 'highlighted');
      });
    });
  };

  var onDoubleMoveClick = function() {
    $('#players').on('click', '.criminal.me.turn .ticket.double-move', function() {
      User.toggleDoubleMove();

      $(this).toggleClass('active', User.doubleMove);
    });
  };

  var svg = function() {
    return d3.select('#' + Board.id);
  };

  var svgNodes = function() {
    return svg().selectAll('circle.node');
  };
})(UiEvents.hook);

