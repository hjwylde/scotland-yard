window.Board = new function() {
  this.id = 'board';

  this.nodes = [];
  this.routes = [];

  this.node = function(id) {
    return this.nodes[id - 1];
  };

  this.findRoutes = function(fromNodeId, toNodeId) {
    return this.routes.filter(function(route) {
      return route.from_node_id === Math.min(fromNodeId, toNodeId) && route.to_node_id === Math.max(fromNodeId, toNodeId);
    });
  };

  this.load = function() {
    var promise = $.when(Loaders.loadNodes(), Loaders.loadRoutes());
    promise.done(function(nodes, routes) {
      this.nodes = nodes[0];
      this.routes = routes[0];
    }.bind(this));

    return promise;
  };

  this.loaded = function() {
    return this.nodes.length && this.routes.length;
  };
};

