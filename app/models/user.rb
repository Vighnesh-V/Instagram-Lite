require 'bcrypt'
# User
class User < ApplicationRecord
  include BCrypt

  def password
    @password ||= Password.new(password_hash) if password_hash
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end
  has_attached_file :avatar,
                    styles: { medium: '150x150>', thumb: '30x30>' },
                    default_url: '/images/:style/missing.png'
  validates_attachment_content_type :avatar, content_type: %r{\Aimage\/.*\z}
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :userlikes, dependent: :destroy
  has_many :friendships, dependent: :destroy
  has_many :friends,
           -> { where(friendships: { state: 'accepted' }) },
           through: :friendships
  has_many :requested_friends,
           -> { where(friendships: { state: 'requested' }) },
           through: :friendships, source: :friend
  has_many :pending_friends,
           -> { where(friendships: { state: 'pending' }) },
           through: :friendships, source: :friend

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :handle, presence: true
  validates :password_hash, presence: true
  validate :good_email

  def full_name
    "#{first_name} #{last_name}"
  end

  def retrieve_handle
    "@#{handle}"
  end

  def send_friend_request(friend)
    b = !Friendship.exists?(user: self, friend: friend) &&
        !Friendship.exists?(user: friend, friend: self)
    return unless b
    Friendship.create(user: self, friend: friend, state: 'requested')
    u = User.find(friend.id)
    Friendship.create(user: u, friend: self, state: 'pending')
  end

  def accept_friend_request(friend)
    b = Friendship.exists?(user: friend, friend: self, state: 'requested') &&
        Friendship.exists?(user: self, friend: friend, state: 'pending')
    return unless b
    Friendship.find_by(user: friend, friend: self, state: 'requested')
              .update(state: 'accepted')
    Friendship.find_by(user: self, friend: friend, state: 'pending')
              .update(state: 'accepted')
  end

  def delete_friend(friend)
    b1 = Friendship.exists?(user: self, friend: friend)
    Friendship.find_by(user: self, friend: friend).destroy if b1
    b2 = Friendship.exists?(user: friend, friend: self)
    Friendship.find_by(user: friend, friend: self).destroy if b2
  end

  private

  def good_email
    cond = email && (email.exclude?('@') || email.exclude?('.'))
    errors.add(:email, "must have an '@' and a '.'") if cond
  end
end
