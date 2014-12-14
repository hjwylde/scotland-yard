class Round < ActiveRecord::Base
  STARTING_ROUND_NUMBER = 1

  belongs_to :game, inverse_of: :rounds
  has_many :moves, inverse_of: :round, dependent: :destroy
  has_many :players, through: :moves

  scope :ordered, lambda { order(:game_id, :number) }

  before_validation :init_default_number

  validates :game_id, :number, presence: true
  validates :number,
    uniqueness: { scope: :game_id },
    numericality: { only_integer: true, greater_than_or_equal_to: STARTING_ROUND_NUMBER }

  validate :game_id_follows_previous_round
  validate :number_starts_at_one
  validate :number_is_consecutive
  validate :previous_round_finished

  def criminal_lost?
    # TODO: Make Round#criminal_lost? a policy
    return false if moves.of_criminals.empty?

    criminal_node_id = moves.of_criminals.first.to_node_id

    detectives_node_ids = moves.of_detectives.pluck(:to_node_id)
    if previous
      detectives_node_ids += previous.moves.of_detectives.pluck(:to_node_id)
    end

    detectives_node_ids.include?(criminal_node_id)
  end

  def ongoing?
    !finished?
  end

  def finished?
    RoundFinishedPolicy.new(round: self).finished?
  end

  def previous
    game.rounds.detect { |round| round.number == number - 1 }
  end

  private

  def init_default_number
    self.number ||= STARTING_ROUND_NUMBER
  end

  def game_id_follows_previous_round
    if previous.try!(:game) != game
      errors.add :game_id, "does not match the previous round's game"
    end
  end

  def number_starts_at_one
    if !previous && number != STARTING_ROUND_NUMBER
      errors.add :number, "must start at #{STARTING_ROUND_NUMBER}"
    end
  end

  def number_is_consecutive
    if previous && number != previous.number + 1
      errors.add :number, 'is not consecutive'
    end
  end

  def previous_round_finished
    if previous.try!(:ongoing?)
      errors.add :round, 'cannot be created until all players have moved in the previous round'
    end
  end
end

