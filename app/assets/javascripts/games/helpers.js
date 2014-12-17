window.Helpers = (function(module) {
  var notificationTag = 'notif-turn';

  module.createTurnNotification = function() {
    if (document.hidden) {
      return this.createNotification(notificationTag, "It's your turn!");
    }

    return null;
  };

  return module;
})(window.Helpers || {});

