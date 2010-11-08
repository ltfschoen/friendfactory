class Waves::BaseController < ApplicationController

  DefaultWaveSlug = 'popular'
  
  before_filter :require_lurker

  def show
    store_location
    @wave = Wave::Base.find_by_slug(params[:slug] || DefaultWaveSlug)
    respond_to do |format|
      format.html
    end
  end
    
end
