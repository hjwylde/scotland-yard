window.Helpers = (function(module) {
  module.createNotification = function(tag, body) {
    if (!Notification) {
      return null;
    } else if (Notification.permission === 'default') {
      Notification.requestPermission(function(permission) {
        this.createNotification(tag, body);
      }.bind(this));
    }

    var notification = new Notification(document.title, {
      tag: tag,
      body: body,
      icon: '/assets/logo.png',
    });

    notification.onclick = function(e) {
      window.focus();
      notification.close();
    };

    notification.onshow = function(e) {
      setTimeout(function() {
        notification.close();
      }, 4000)
    };

    return notification;
  };

  return module;
})(window.Helpers || {});

