window.Toast = new function() {
  var counter = 0;

  this.info = function(text) {
    dismissToasts();

    createToast('info'. text).get(0).show();
  };

  this.error = function(text) {
    dismissToasts();

    createToast('error', text).get(0).show();
  };

  var createToast = function(type, text) {
    $('body').append('<paper-toast id="toast' + counter + '" class="' + type + '" text="' + text + '"></paper-toast>');

    return $('#toast' + counter++);
  };

  var dismissToasts = function() {
    $('paper-toast').each(function(t) {
      this.dismiss();

      setTimeout(function() {
        $(this).remove();
      }.bind(this), 2000);
    });
  };
};

