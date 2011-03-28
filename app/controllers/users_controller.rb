class UsersController < ApplicationController

  before_filter :require_no_user
  
  helper_method :new_user

  def create
    respond_to do |format|  
      if new_user.save
        format.html { redirect_to root_path }
      else                
        format.html { render :template => 'welcome/show', :layout => 'welcome' }
      end
    end  
  end
  
  private
  
  def new_user
    @user ||= User.find_or_create_by_email(params[:user]).tap do |user|
      user.enrollment_site = current_site
    end
  end
    
end
