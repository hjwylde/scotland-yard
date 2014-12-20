window.Loaders = (function(module) {
  module.loadUser = function() {
    var request = $.get(Routes.user_path(), null, null, 'json');

    request.then(function(user) {
      user.player_indices = user.player_ids.map(Helpers.idToIndex);

      return user;
    });

    return request;
  };

  return module;
})(window.Loaders || {});

