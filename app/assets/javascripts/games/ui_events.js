(function(hook) {
  UiEvents.hook = function(force) {
    // Call parent hook first
    hook(force);

    onWindowResize();
  };

  // PRIVATE

  var onWindowResize = function() {
    setBodyHeight();

    $(window).bind('resize', function() {
      setBodyHeight();
    });
  };

  var setBodyHeight = function() {
    $('body').attr('style', 'height: ' + $(window).height() + 'px;');
  };
})(UiEvents.hook);

