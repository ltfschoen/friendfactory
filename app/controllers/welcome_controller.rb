class WelcomeController < ApplicationController

  before_filter :require_no_user
  before_filter :clear_lurker
  
  def index
    store_reentry_location
  end
  
  def launch
    current_site.name = 'positivelyfrisky'
    render :layout => false
  end
  
end
