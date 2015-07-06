(function() {
  $(function() {
    if ($('core-header-panel').length) {
      init();
    }
  });

  var init = function() {
    var icon = $('core-header-panel core-toolbar paper-icon-button');

    icon.on('click', function() {
      window.location.href = icon.data('href');
    });
  };
})();

