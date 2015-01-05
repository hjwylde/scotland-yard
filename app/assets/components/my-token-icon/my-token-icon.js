Polymer('my-token-icon', {
  token: 'null',
  count: 0,
  active: '',

  icon: function() {
    switch (this.token) {
      case 'double-move':
        return '';
      default:
        return '';
    }
  },

  onTap: function() {
    if (this.count > 0) {
      User.toggleDoubleMove();

      this.active = User.doubleMove ? 'active' : '';
    }
  },
});

