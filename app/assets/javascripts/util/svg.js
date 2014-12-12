window.Svg = new function() {
  // The standard jQuery class modifiers don't work for SVG elements
  // These methods are defined to replace them

  this.containsClass = function(elem, symbol) {
    return elem.attr('class').indexOf(symbol) >= 0;
  };

  this.addClass = function(elem, symbol) {
    if (!this.containsClass(elem, symbol)) {
      elem.attr('class', elem.attr('class') + ' ' + symbol);
    }
  };

  this.removeClass = function(elem, symbol) {
    elem.attr('class', elem.attr('class').replace(symbol, '').trim());
  };

  this.toggleClass = function(elem, symbol) {
    if (containsClass(elem, symbol)) {
      removeClass(elem, symbol);
    } else {
      addClass(elem, symbol);
    }
  };
};

