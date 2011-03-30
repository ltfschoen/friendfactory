class WelcomeController < ApplicationController

  before_filter :require_no_user
  before_filter :require_launch_site, :only => [ :launch ]
  before_filter :clear_lurker

  def show
    respond_to do |format|
      if current_site.launch?
        @launch_user = LaunchUser.new
        format.html { render :action => 'launch' }
      else
        @user = find_or_create_user_by_invitation_code
        format.html
      end
    end
  end
    
  def launch
    respond_to do |format|
      flash[:launch_user] = new_launch_user.save
      format.html { redirect_to welcome_path }
    end
  end
  
  private
  
  def find_or_create_user_by_invitation_code
    invitation = Invitation.find_all_by_code(params[:invite])
    user = (invitation.length == 1 && invitation.first.user) || User.new
    user.tap do |user|
      user.handle = user.profiles.first.try(:handle)
      user.enrollment_site = current_site
      user.invitation_code = params[:invite]
    end
  end
    
  def new_launch_user
    LaunchUser.new(params[:launch_user]).tap do |user|
      user.site = current_site.name
    end
  end
  
  def require_launch_site
    redirect_to welcome_path unless current_site.launch?
  end
    
end
