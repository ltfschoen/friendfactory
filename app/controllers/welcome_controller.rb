class WelcomeController < ApplicationController

  before_filter :require_no_user,     :only => [ :index ]
  before_filter :require_launch_site, :only => [ :index ]
  before_filter :clear_lurker,        :only => [ :index ]

  helper_method :new_user
  
  def index
    store_reentry_location
    redirect_to launch_url if current_site.launch?
  end
  
  def launch
    respond_to do |format|
      if request.post?
        LaunchUser.create(params[:launch_user].merge(:site => current_site))
        flash[:launch_user] = true
        format.html { redirect_to launch_path }
      else
        format.html
      end
    end
  end

  private
  
  def require_launch_site
    redirect_to launch_url if current_site.launch?
  end
  
  def new_user
    User.new.tap { |user| user.profiles.build }
  end
    
end
