window.Loaders = (function(module) {
  module.loadRoutes = function() {
    return $.get(Routes.routes_path(), null, null, 'json');
  };

  return module;
})(window.Loaders || {});

