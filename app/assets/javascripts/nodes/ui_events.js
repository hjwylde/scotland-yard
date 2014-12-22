(function(hook) {
  UiEvents.hook = function() {
    // Call parent hook first
    hook();

    onNodeClick();
    onNodeHover();
  };

  // PRIVATE

  var onNodeClick = function() {
    $('circle.node').click(function() {
      var fromNodeId = User.player().current_node_id;
      var toNodeId = $(this).attr('data-id');
      var routes = Board.findRoutes(fromNodeId, toNodeId);

      routes = routes.filter(function(route) {
        return User.player().ticket_counts[route.transport_mode] > 0;
      });

      var ticket = null;
      switch (routes.length) {
        case 0:
          return;
        case 1:
          ticket = routes[0].transport_mode;
          break;
        default:
          ticket = showTicketPrompt(routes.map(function(route) { return route.transport_mode; }));
      }

      if (!ticket) {
        return;
      }

      var promise = Savers.savePlayerMove(Game.id, User.player().id, {
        move: {
          to_node_id: toNodeId,
          ticket: ticket.toLowerCase(),
          token: User.doubleMove ? 'double_move' : null
        }
      })
      promise.done(function() {
        Game.refresh().done(function() {
          User.doubleMove = false;

          if (Game.finished()) {
            // Refresh the page to show the finish screen
            location.href = Routes.game_path(Game.id);
          } else {
            // Re-render the board players to show the made move
            Renderer.refresh();
          }
        });
      });
      promise.fail(function(error) {
        // TODO: promise.fail
        console.error('error saving move');
        console.error(error);
      });
    });
  };

  var showTicketPrompt = function(options) {
    return prompt('Pick your ticket: ' + options.join(', '));
  };

  var onNodeHover = function() {
    // Highlight the node and adjacent nodes node on the board when the user hovers the mouse
    $('circle.node').hover(function() {
      var id = $(this).attr('data-id');

      // Highlight both hovered and adjacent nodes
      svgNodes().each(function(node) {
        if (node.id === id || $.inArray(node.id, Board.node(id).linked_node_ids) >= 0) {
          Helpers.addClass(d3.select(this), 'highlighted');
        }
      });
    }, function() {
      // Remove the highlight
      $('.highlighted').each(function() {
        Helpers.removeClass($(this), 'highlighted');
      });
    });
  };

  var svg = function() {
    return d3.select('#' + Board.id);
  };

  var svgNodes = function() {
    return svg().selectAll('circle.node');
  };
})(UiEvents.hook);

