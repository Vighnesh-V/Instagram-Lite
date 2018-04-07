class WelcomeController < ApplicationController
  def index
  	@name = "not logged in"
  	return unless logged_in?
  	@name = current_user.full_name
  end
end
