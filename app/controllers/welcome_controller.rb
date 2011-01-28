class WelcomeController < ApplicationController

  before_filter :require_no_user, :only => [ :index ]
  before_filter :clear_lurker, :only => [ :index ]
  
  def index
    store_reentry_location
    redirect_to launch_url if current_site.name == 'positivelyfrisky'
  end
  
  def launch
    respond_to do |format|
      if request.post?
        LaunchUser.create(params[:launch_user])
        flash[:launch_user] = true
        format.html { redirect_to launch_path }
      else
        format.html
      end
    end
  end
    
end
