class WelcomeController < ApplicationController

  before_filter :require_no_user, :only => [ :index ]
  before_filter :clear_lurker, :only => [ :index ]
  
  def index
    store_reentry_location
  end
  
  def launch
    render :layout => false
  end
  
end
