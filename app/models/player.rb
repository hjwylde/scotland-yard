class Player < ActiveRecord::Base
  belongs_to :game, inverse_of: :players
  belongs_to :user, inverse_of: :players
  belongs_to :origin_node, class_name: 'Node', inverse_of: :players

  has_many :moves, lambda { includes(:round).ordered }, inverse_of: :player, dependent: :destroy
  has_many :rounds, lambda { ordered }, through: :moves

  scope :ordered, lambda { order(:game_id, :type, :id) }
  scope :detectives, lambda { where(type: Detective) }
  scope :criminals, lambda { where(type: Criminal) }

  before_validation :init_random_origin_node

  validates :game_id, :user_id, :type, :origin_node_id, presence: true
  validates :user_id, uniqueness: { scope: :game_id }
  validates :type, inclusion: { in: %w(Detective Criminal) }

  validate :origin_node_is_origin_node
  validate :origin_node_is_unused

  def name
    user.name
  end

  def detective?
    type == Detective.name
  end

  def criminal?
    type == Criminal.name
  end

  def move_nodes
    moves.preload(:to_node).map(&:to_node)
  end

  def move_node_ids
    moves.pluck(:to_node_id)
  end

  def current_node
    moves.preload(:to_node).last.try!(:to_node) || origin_node
  end

  def current_node_id
    moves.last.try!(:to_node_id) || origin_node_id
  end

  private

  def init_random_origin_node
    self.origin_node ||= (Node.origins - game.players.map(&:origin_node)).sample if game
  end

  def origin_node_is_origin_node
    if !origin_node.try!(:origin?)
      errors.add :origin_node_id, 'is not an origin node'
    end
  end

  def origin_node_is_unused
    if game && game.players.where.not(id: id).where(origin_node_id: origin_node_id).exists?
      errors.add :origin_node_id, 'is already used by another player'
    end
  end
end

