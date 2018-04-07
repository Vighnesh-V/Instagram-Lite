class SessionsController < ApplicationController
  def new; end

  def create
    @user = User.find_by(email: params[:email])
    if @user && @user.password == params[:password]
      session[:user_id] = @user.id
      redirect_to root_path
    else
      redirect_to '/login'
    end
  end

  def destroy
    reset_session
    redirect_to root_path
  end
end
