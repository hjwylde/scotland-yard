window.Loaders = (function(module) {
  module.loadNodes = function() {
    return $.get(Routes.nodes_path(), null, null, 'json');
  };

  return module;
})(window.Loaders || {});

