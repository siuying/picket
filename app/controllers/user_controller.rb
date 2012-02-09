class UserController < ApplicationController
  before_filter :authenticate_user!

  def index
    @user = current_user
  end
  
  def update
    @user = User.find(current_user.id)
  
    if params[:user][:password].empty? && params[:user][:password_confirmation].empty?
      if @user.update_without_password(params[:user])
        sign_in @user, :bypass => true
        flash[:notice] = "User profile updated"
      else
        flash[:error] = "Error updating password"
      end
    
    else
      if @user.update_attributes(params[:user])
        sign_in @user, :bypass => true
        flash[:notice] = "User profile updated"
      else
        flash[:error] = "Error updating password"
      end
    end

    redirect_to profile_path
  end
end
