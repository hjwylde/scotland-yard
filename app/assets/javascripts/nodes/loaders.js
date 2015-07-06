window.Loaders = (function(module) {
  module.loadNodes = function() {
    var promise = $.get(Routes.nodes_path(), null, null, 'json');
    promise.done(function(nodes) {
      nodes.forEach(function(node) {
        node.getX = function() {
          return this.x * Board.width;
        };

        node.getY = function() {
          return this.y * Board.height;
        };
      });
    });

    return promise;
  };

  return module;
})(window.Loaders || {});

