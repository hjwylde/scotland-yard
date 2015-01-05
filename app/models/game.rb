class Game < ActiveRecord::Base
  NAME = 'Scotland Yard'
  NUMBER_OF_PLAYERS = 6

  has_many :players, lambda { ordered }, inverse_of: :game, dependent: :destroy
  has_many :rounds, lambda { ordered }, inverse_of: :game, dependent: :destroy
  has_many :moves, lambda { ordered }, through: :rounds

  before_validation :init_default_name

  validates :name, length: { minimum: 1 }
  # TODO: Check that this validation is done when a player is saved
  validates :players, length: { maximum: NUMBER_OF_PLAYERS }

  def detectives
    players.detectives
  end

  def criminals
    players.criminals
  end

  def current_round
    rounds.last
  end

  def initialising?
    rounds.empty?
  end

  def started?
    !initialising?
  end

  def ongoing?
    started? && !finished?
  end

  def finished?
    GameFinishedPolicy.new(game: self).finished?
  end

  private

  def init_default_name
    self.name ||= "#{Time.now.strftime('%Y-%m-%d %H:%M:%S')}"
  end
end

