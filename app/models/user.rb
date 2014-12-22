class User < ActiveRecord::Base
  has_many :players, inverse_of: :user, dependent: :destroy
  has_many :games, through: :players

  validates :name, presence: true, uniqueness: true, length: { minimum: 1 }
end

