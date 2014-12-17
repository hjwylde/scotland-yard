window.Helpers = (function(module) {
  module.idToIndex = function(id) {
    return id - 1;
  };

  // The standard jQuery class modifiers don't work for SVG elements
  // These methods are defined to replace them

  module.containsClass = function(elem, symbol) {
    return elem.attr('class').indexOf(symbol) >= 0;
  };

  module.addClass = function(elem, symbol) {
    if (!this.containsClass(elem, symbol)) {
      elem.attr('class', elem.attr('class') + ' ' + symbol);
    }
  };

  module.removeClass = function(elem, symbol) {
    elem.attr('class', elem.attr('class').replace(symbol, '').trim());
  };

  module.toggleClass = function(elem, symbol) {
    if (containsClass(elem, symbol)) {
      removeClass(elem, symbol);
    } else {
      addClass(elem, symbol);
    }
  };

  return module;
})(window.Helpers || {});

