class Wave::CommunitiesController < ApplicationController

  DefaultWaveSlug = 'popular'

  before_filter :require_user
  layout 'community'

  cattr_reader :per_page
  @@per_page = 50

  def show
    @wave = current_site.home_wave
    @postings = @wave.postings.published.includes(:user).order('sticky_until desc, updated_at desc').paginate(:page => params[:page], :per_page => @@per_page)
    # @profiles = @postings.map(&:user).uniq.map{ |user| user.profile(current_site) }.uniq
    respond_to do |format|
      format.html
    end
  end

end
