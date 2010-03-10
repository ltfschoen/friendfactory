class UserSessionsController < ApplicationController
  
  before_filter :require_no_user, :only => [ :new, :create ]
  before_filter :require_user,    :only => :destroy
  
  def new
    @user_session = UserSession.new
  end
  
  def create
    params[:user_session][:email] = nil if params[:user_session].try(:[], :email) == helpers.placeholder_for(:email)
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Login successful!"
      redirect_to root_path
    else
      render :action => :new
    end
  end
  
  def destroy
    current_user_session.destroy
    flash[:notice] = "Logout successful!"
    redirect_to login_url
  end
  
end
