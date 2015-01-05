window.Loaders = (function(module) {
  module.loadUser = function() {
    return $.get(Routes.user_path(), null, null, 'json');
  };

  return module;
})(window.Loaders || {});

