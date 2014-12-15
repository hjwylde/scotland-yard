window.UiEvents = new function() {
  this.hook = function(force) {
    onNodeClick(force);
    onNodeHover();
    onMoveMouseEnter();
    onMoveMouseLeave();
    onCurrentNodeMouseEnter();
    onCurrentNodeMouseLeave();

    onWindowResize();
  };

  // PRIVATE

  var onNodeClick = function(force) {
    $('circle.node').click(function() {
      var fromNodeId = User.player().current_node_id;
      var toNodeId = $(this).attr('data-id');
      var routes = Board.findRoutes(Math.min(fromNodeId, toNodeId), Math.max(fromNodeId, toNodeId));

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

      if (ticket == null || ticket == '') {
        return;
      }

      var promise = Savers.savePlayerMove(Game.id, User.player().id, { move: { to_node_id: toNodeId, ticket: ticket.toLowerCase() } })
      promise.done(function() {
        Game.refresh().done(function() {
          if (Game.finished()) {
            // Refresh the page to show the finish screen
            window.location.href = Routes.game_path(Game.id);
          } else {
            // Re-render the board players to show the made move
            Renderer.render();
            force.start();
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
        if (node.id == id || $.inArray(node.id, Board.node(id).linked_node_ids) >= 0) {
          Svg.addClass(d3.select(this), 'highlighted');
        }
      });
    }, function() {
      // Remove the highlight
      $('.highlighted').each(function() {
        Svg.removeClass($(this), 'highlighted');
      });
    });
  };

  var onMoveMouseEnter = function() {
    // Highlight the node on the board when the user hovers over a player move
    $('#players').on('mouseenter', 'div.move:not(.hide)', function() {
      id = $(this).text();

      svg().select('circle.node[data-id="' + id + '"]').each(function(node) {
        Svg.addClass(d3.select(this), 'highlighted');
      });
    });
  };

  var onMoveMouseLeave = function() {
    $('#players').on('mouseleave', 'div.move:not(.hide)', function() {
      id = $(this).text();

      svg().select('circle.node[data-id="' + id + '"]').each(function(node) {
        Svg.removeClass(d3.select(this), 'highlighted');
      });
    });
  };

  var onCurrentNodeMouseEnter = function() {
    // Highlight the node on the board when the user hovers over a player current node
    $('#players').on('mouseenter', 'div.current-node', function() {
      id = $(this).parent().closest('div.player').attr('data-id');

      svg().select('circle.player[data-id="' + id + '"]').each(function(node) {
        Svg.addClass(d3.select(this), 'highlighted');
      });
    });
  };

  var onCurrentNodeMouseLeave = function() {
    $('#players').on('mouseleave', 'div.current-node', function() {
      id = $(this).parent().closest('div.player').attr('data-id');

      svg().select('circle.player[data-id="' + id + '"]').each(function(node) {
        Svg.removeClass(d3.select(this), 'highlighted');
      });
    });
  };

  var onWindowResize = function() {
    setBodyHeight();

    $(window).bind('resize', function() {
      setBodyHeight();
    });
  };

  var svg = function() {
    return d3.select('#' + Board.id);
  };

  var svgNodes = function() {
    return svg().selectAll('circle.node');
  };

  var setBodyHeight = function() {
    $('body').attr('style', 'height: ' + $(window).height() + 'px;');
  };
};

