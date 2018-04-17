class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: 'User'

  validates :state, presence: true, inclusion: { in: ['accepted', 'pending', 'requested'] }
  #validates :friend, uniqueness: true
  validate :self_friend

  private

  def self_friend
    errors.add(:user, 'cannot friend themself') if user.eql? friend
  end
end
