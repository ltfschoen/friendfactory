class UserSessionsController < ApplicationController
  
  before_filter :require_no_user, :only => [ :new, :create ]
  before_filter :require_user,    :only => :destroy
  
  def new
    @user_session = UserSession.new
  end
  
  def create
    params[:user_session][:email] = nil if params[:user_session].try(:[], :email) == helpers.placeholder_for(:email)
    @user_session = UserSession.new(params[:user_session])
    respond_to do |format|
      if @user_session.save
        @current_user = UserSession.find
        Pusher['wave'].trigger('user-online', { :full_name => current_user.full_name })
        flash[:notice] = "Login successful!"
        format.html { redirect_to root_path }
        format.js
      else
        format.html { render :action => :new }
        format.js
      end      
    end
  end
  
  def destroy
    current_user.update_attribute(:current_login_at, nil)
    current_user_session.destroy
    Pusher['wave'].trigger('user-offline', { :full_name => current_user.full_name })
    flash[:notice] = "Logout successful!"
    respond_to do |format|
      format.html { redirect_to welcome_url }
    end
  end
end
