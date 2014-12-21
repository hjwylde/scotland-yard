(function(hook) {
  UiEvents.hook = function() {
    // Call parent hook first
    hook();

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

