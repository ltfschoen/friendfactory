require 'user_enrollment'

class UserSessionsController < ApplicationController

  include UserEnrollment

  before_filter :require_lurker, :only => :new
    
  def new    
    @user_session = UserSession.new
  end  
  
  def create
    respond_to do |format|
      if login(params[:user_session], :skip_enrollment_validation => false)
        flash[:notice] = "Welcome back, #{user_session.record.handle(current_site)}!"
        format.html { redirect_back_or_default(root_path) }          
      else
        flash[:notice] = "Sorry, but that #{user_session.errors.full_messages.first.downcase}."
        format.html { redirect_to welcome_path }          
      end
    end
  end
  
  def lurk
    store_lurker
    respond_to do |format|
      format.html { redirect_back_or_default(root_path) }
    end
  end

  def destroy
    destroy_session
    respond_to do |format|
      format.html { redirect_to root_path }
    end
  end
  
  private
    
  def destroy_session
    clear_lurker
    if current_user
      current_user.update_attribute(:current_login_at, nil)
      current_user_session.destroy
    end
  end
    
end
