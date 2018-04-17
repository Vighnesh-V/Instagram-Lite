require 'bcrypt'
class User < ApplicationRecord
  include BCrypt

  def password
    @password ||= Password.new(password_hash) if password_hash
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end
  has_attached_file :avatar, styles: { medium: "150x150>", thumb: "30x30>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :userlikes, dependent: :destroy
  has_many :friendships, dependent: :destroy
  has_many :friends,
	  -> { where(friendships: {state: 'accepted'}) }, through: :friendships
  has_many :requested_friends,
	  -> {where(friendships: {state: 'requested'}) }, through: :friendships, source: :friend
  has_many :pending_friends,
	  -> { where(friendships: { state: 'pending' }) }, through: :friendships, source: :friend

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
    return unless !Friendship.exists?(user: self, friend: friend) && !Friendship.exists?(user: friend, friend: self)
    Friendship.create(user: self, friend: friend, state: 'requested')
    Friendship.create(user: User.find(friend.id), friend: self, state: 'pending')
  end

  def accept_friend_request(friend)
    return unless Friendship.exists?(user: friend, friend: self, state: 'requested') && Friendship.exists?(user: self, friend: friend, state: 'pending')
    Friendship.find_by(user: friend, friend: self, state: 'requested').update(state: 'accepted')
    Friendship.find_by(user: self, friend: friend, state: 'pending').update(state: 'accepted')
  end

  def delete_friend(friend)
    Friendship.find_by(user: self, friend: friend).destroy if Friendship.exists?(user: self, friend: friend)
    Friendship.find_by(user: friend, friend: self).destroy if Friendship.exists?(user: friend, friend: self)
  end

  private

  def good_email
    errors.add(:email, "must have an '@' and a '.'") if email && (email.exclude?('@') || email.exclude?('.'))
  end
end