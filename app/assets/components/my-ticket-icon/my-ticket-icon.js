Polymer('my-ticket-icon', {
  ticket: 'null',
  count: 0,

  icon: function() {
    switch (this.ticket) {
      case 'taxi':
        return 'directions-taxi';
      case 'bus':
        return 'directions-bus';
      case 'underground':
        return 'directions-subway';
      case 'black':
        return 'navigation';
      default:
        return '';
    }
  },
});

