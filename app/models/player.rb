class Player < ActiveRecord::Base
  belongs_to :game, inverse_of: :players
  belongs_to :origin_node, class_name: 'Node', inverse_of: :players
  has_many :moves, inverse_of: :player, dependent: :destroy
  has_many :rounds, through: :moves

  scope :ordered, lambda { order(:game_id, :type, :id) }
  scope :detectives, lambda { where(type: Detective) }
  scope :criminals, lambda { where(type: Criminal) }

  before_validation :init_default_name, :init_random_origin_node

  validates :game_id, :name, :type, :origin_node_id, presence: true
  validates :name, uniqueness: { scope: :game_id }
  validates :type, inclusion: { in: %w(Detective Criminal) }

  validate :origin_node_is_origin_node
  validate :origin_node_is_unused

  def detective?
    type == Detective.name
  end

  def criminal?
    type == Criminal.name
  end

  def move_nodes
    moves.includes(:to_node).ordered.map(&:to_node)
  end

  def move_node_ids
    moves.ordered.pluck(:to_node_id)
  end

  def current_node
    moves.includes(:to_node).ordered.last.try!(:to_node) || origin_node
  end

  def current_node_id
    moves.ordered.last.try!(:to_node_id) || origin_node_id
  end

  def tickets_count
    CountPlayerTicketsService.new(player: self).call
  end

  private

  def init_default_name
    self.name ||= "#{type} ##{1 + (detective? ? game.detectives.count : 0)}" if game
  end

  def init_random_origin_node
    self.origin_node ||= (Node.origins - game.players.map(&:origin_node)).sample if game
  end

  def origin_node_is_origin_node
    if origin_node && !origin_node.origin?
      errors.add :origin_node_id, 'is not an origin node'
    end
  end

  def origin_node_is_unused
    if game && game.players.where.not(id: id).where(origin_node_id: origin_node_id).exists?
      errors.add :origin_node_id, 'is already used by another player'
    end
  end
end

