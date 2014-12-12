class Move < ActiveRecord::Base
  TICKET_TYPES = [:taxi, :bus, :underground, :black, :double_move]

  belongs_to :round, inverse_of: :moves
  belongs_to :player, inverse_of: :moves
  belongs_to :to_node, class_name: 'Node', inverse_of: :moves

  scope :ordered, lambda { joins(:round).order('rounds.game_id', 'rounds.number', :player_id) }
  scope :of_detectives, lambda { joins(:player).where('players.type' => Detective) }
  scope :of_criminals, lambda { joins(:player).where('players.type' => Criminal) }

  validates :round_id, :player_id, :to_node_id, :ticket, presence: true
  validates :player_id, uniqueness: { scope: :round_id }
  validates :ticket, inclusion: { in: TICKET_TYPES }

  validate :player_is_in_the_game
  validate :move_is_not_reflexive

  private

  def player_is_in_the_game
    if round.game.players.exclude?(player)
      errors.add :player_id, 'is not in this game'
    end
  end

  def move_is_not_reflexive
    if player.current_node == to_node
      errors.add :to_node, "is the same as the player's current node"
    end
  end
end

