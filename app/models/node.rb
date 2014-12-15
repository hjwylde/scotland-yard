class Node < ActiveRecord::Base
  has_many :incoming_routes, class_name: 'Route', foreign_key: :to_node_id, inverse_of: :to_node, dependent: :destroy
  has_many :outgoing_routes, class_name: 'Route', foreign_key: :from_node_id, inverse_of: :from_node, dependent: :destroy

  has_many :moves, class_name: 'Move', foreign_key: :to_node_id, inverse_of: :to_node, dependent: :destroy
  has_many :players, class_name: 'Player', foreign_key: :origin_node_id, inverse_of: :origin_node, dependent: :destroy

  scope :origins, lambda { where(origin: true) }

  before_validation :init_default_origin

  validates :origin, inclusion: { in: [true, false] }
  validates :x, :y, allow_nil: true, numericality: { greater_than_or_equal_to: 0.0, less_than_or_equal_to: 1.0 }

  validate :no_two_origin_nodes_linked

  def routes
    incoming_routes + outgoing_routes
  end

  def linked_nodes
    (incoming_routes.select(:from_node_id).distinct.map(&:from_node) + outgoing_routes.select(:to_node_id).distinct.map(&:to_node))
  end

  def linked_node_ids
    (incoming_routes.pluck(:from_node_id) + outgoing_routes.pluck(:to_node_id)).uniq
  end

  def transport_modes
    (incoming_routes.pluck(:transport_mode) + outgoing_routes.pluck(:transport_mode)).uniq.map(&:to_sym)
  end

  private

  def init_default_origin
    self.origin = false if origin.nil?
  end

  def no_two_origin_nodes_linked
    if origin? && linked_nodes.any?(&:origin?)
      errors.add :origin, 'cannot be set when a linked node is also an origin node'
    end
  end
end

