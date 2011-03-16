class Wave::CommunitiesController < ApplicationController

  DefaultWaveSlug = 'popular'
  
  before_filter :require_user

  cattr_reader :per_page
  @@per_page = 60
  
  def show
    store_location
    @wave = Wave::Base.site(current_site).find_by_slug(params[:slug] || DefaultWaveSlug)
    @postings = @wave.postings.published.includes(:user).paginate(:page => params[:page], :per_page => @@per_page)
    respond_to do |format|
      format.html
    end
  end
  
end
