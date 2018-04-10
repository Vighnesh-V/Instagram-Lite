class Post < ApplicationRecord
  belongs_to :user
  has_attached_file :image, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
  has_many :comments, dependent: :destroy
  has_many :userlikes, dependent: :destroy
  has_many :likes,
  -> { where(userlikes: {state: 'liked'})}, through: :userlikes

  def like_post(liker)
  	return if Userlike.exists?(user: liker, post: self, state: 'liked')
  	Userlike.create(user: liker, post: self, state: 'liked')
  end

  def unlike_post(liker)
    return unless Userlike.exists?(user: liker, post: self, state: 'liked')
    Userlike.find_by(user: liker, post: self, state: 'liked').destroy
  end

  def user_liked_post(liker)
    Userlike.exists?(user: liker, post: self, state: 'liked')
  end

end
