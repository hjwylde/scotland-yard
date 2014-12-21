class Route < ActiveRecord::Base
  TRANSPORT_MODES = [:taxi, :bus, :underground, :boat, :black]

  belongs_to :from_node, class_name: 'Node', inverse_of: :outgoing_routes
  belongs_to :to_node, class_name: 'Node', inverse_of: :incoming_routes

  scope :ordered, lambda { order(:from_node_id, :to_node_id) }

  validates :from_node_id, :to_node_id, :transport_mode, presence: true
  validates :transport_mode,
      inclusion: { in: TRANSPORT_MODES },
      uniqueness: { scope: [:from_node_id, :to_node_id] }

  validate :to_node_is_after_from_node
  validate :does_not_link_two_origin_nodes

  private

  def to_node_is_after_from_node
    # The routes are undirected, hence a route from 1 -> 2 and 2 -> 1 are the same
    # Thus, we force the to_node to be the lesser one for consistency and to allow easy searching,
    # e.g., Route.where(to_node_id: node_ids.min, from_node_id: node_ids.max)
    if to_node_id <= from_node_id
      errors.add :to_node_id, 'must be after the from node'
    end
  end

  def does_not_link_two_origin_nodes
    if from_node.origin? && to_node.origin?
      errors.add :to_node_id, 'cannot link two origin nodes'
    end
  end
end

