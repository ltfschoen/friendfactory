class WelcomeController < ApplicationController

  before_filter :require_no_user
  before_filter :require_launch_site, :only => [ :launch, :create ]
  before_filter :clear_lurker

  helper_method :new_user, :new_launch_user
  
  def show
    respond_to do |format|
      if current_site.launch?
        format.html { render :action => 'launch' }
      else
        format.html
      end
    end
  end
  
  def create
    respond_to do |format|      
      flash[:launch_user] = new_launch_user.save
      format.html { redirect_to welcome_path }
    end
  end

  private
  
  def new_user
    @user ||= User.new.tap { |user| user.profiles.build }
  end
  
  def new_launch_user
    @launch_user ||= begin
      LaunchUser.new(params[:launch_user]).tap do |user|
        user.site = current_site.name
      end
    end
  end
  
  def require_launch_site
    redirect_to welcome_path unless current_site.launch?
  end
    
end
