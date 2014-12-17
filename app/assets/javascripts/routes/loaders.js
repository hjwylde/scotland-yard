window.Loaders = (function(module) {
  module.loadRoutes = function() {
    var request = $.get(Routes.routes_path());

    request.then(function(routes) {
      routes.forEach(function(route) {
        route.from_node_index = Helpers.idToIndex(route.from_node_id);
        route.to_node_index = Helpers.idToIndex(route.to_node_id);

        route.source = route.from_node_index;
        route.target = route.to_node_index;
      });

      return routes;
    });

    return request;
  };

  return module;
})(window.Loaders || {});

