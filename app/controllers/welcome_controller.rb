class WelcomeController < ApplicationController

  def index
  	@post = Post.new
    return unless logged_in?
    @posts = Post.where(user: current_user.friends).or(Post.where(user: current_user)).order(created_at: :desc)
  end

end
