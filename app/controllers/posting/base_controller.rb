class Posting::BaseController < ApplicationController

  before_filter :require_user
  before_filter :require_resolver

  private
  
  def require_resolver
    @resolver = params[:resolver]
  end

end