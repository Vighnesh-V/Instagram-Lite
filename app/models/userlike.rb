# UserLike
class Userlike < ApplicationRecord
  belongs_to :user
  belongs_to :post
  validates :state, presence: true, inclusion: { in: %w[liked] }
end
