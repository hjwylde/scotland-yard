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
      if (User.player().id !== Game.activePlayer.id) {
        Toast.error("It's not your turn");
        return;
      }

      var fromNodeId = User.player().current_node_id;
      var toNodeId = $(this).attr('data-id');
      var routes = Board.findRoutes(fromNodeId, toNodeId);

      if (routes.length == 0) {
        Toast.error("There's no route to that node");
        return;
      }

      routes = routes.filter(function(route) {
        return User.player().ticket_counts[route.transport_mode] > 0;
      });

      var ticket = null;
      switch (routes.length) {
        case 0:
          Toast.error("You don't have enough tickets to move there");
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
        console.error('error saving move');
        console.error(error);

        errors = JSON.parse(error.responseText).errors;

        Toast.error(errors.join('\n'));
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
      Svg.nodes().each(function(node) {
        if (node.id === id || $.inArray(node.id, Board.node(id).adjacent_node_ids) >= 0) {
          d3.select(this).classed('highlighted', true);
        }
      });
    }, function() {
      // Remove the highlight
      $('.highlighted').each(function() {
        d3.select(this).classed('highlighted', false);
      });
    });
  };
})(UiEvents.hook);

