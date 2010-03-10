class HomeController < ApplicationController  

  before_filter :require_user

  helper :welcome

  def index
    respond_to do |format|
      format.html
    end
  end
  
end
