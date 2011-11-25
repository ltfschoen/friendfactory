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
        params[:invite].strip! if params[:invite].present?
        @user = User.find_by_invitation_code(params[:invite]) || User.new
        @user.enrollment_site = current_site
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

  def headshot
    render :text => params[:pane]
  end

  private
      
  def new_launch_user
    LaunchUser.new(params[:launch_user]).tap do |user|
      user.site = current_site.name
    end
  end

  def require_launch_site
    redirect_to welcome_path unless current_site.launch?
  end

end
