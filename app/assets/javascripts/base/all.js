(function() {
  $(function() {
    init();
  });

  var init = function() {
    // Initialise the user
    var promise = User.load();
    promise.fail(function(response) {
      // TODO: promise.fail
      console.error('unable to load the user');
      console.error(response);
    });
  };
})();

