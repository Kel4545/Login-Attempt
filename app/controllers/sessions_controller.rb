class SessionsController < ApplicationController
  skip_before_action :ensure_current_user

  def new
    @user = User.new
  end

  def create
    @user = User.find_by(email: params[:user][:email])
    if @user && @user.password == params[:user][:password]
      session[:user_id] = @user.id
      @user.erase_logins
      p "You're Super smart"
      redirect_to root_path
    elsif @user
      if @user.logins == 0
        p "logins are 0"
        @user.login_attempt_counter
        redirect_to :back
      else
        p "logins are more than 4"
        @user.wait_2_minutes
        redirect_to :back
      end
      @user.check_user_logins
      render :new
    end
  end
end
