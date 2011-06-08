class Wave::CommunitiesController < ApplicationController

  DefaultWaveSlug = 'popular'
  
  before_filter :require_user

  cattr_reader :per_page
  @@per_page = 30
  
  def show
    @wave = current_site.home_wave
    @postings = @wave.postings.published.includes(:user).order('updated_at desc').paginate(:page => params[:page], :per_page => @@per_page)
    respond_to do |format|
      format.html
    end
  end
  
end
