window.Loaders = (function(module) {
  module.loadNodes = function() {
    var request = $.get(Routes.nodes_path(), null, null, 'json');

    request.then(function(nodes) {
      nodes.forEach(function(node) {
        node.index = Helpers.idToIndex(node.id);
        node.linked_node_indices = node.linked_node_ids.map(Helpers.idToIndex);
      });

      return nodes;
    });

    return request;
  };

  return module;
})(window.Loaders || {});

