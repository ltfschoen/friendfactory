class Wave::CommunitiesController < ApplicationController

  DefaultWaveSlug = 'popular'

  before_filter :require_user

  layout 'community'

  cattr_reader :per_page
  @@per_page = 50

  helper_method :wave, :postings, :profiles

  def show
    respond_to { |format| format.html }
  end

  def rollcall
    respond_to { |format| format.html }
  end

  private

  def wave
    @wave ||= current_site.home_wave
  end

  def postings
    @postings ||= wave.postings.published.includes(:user).order('sticky_until desc, updated_at desc').paginate(:page => params[:page], :per_page => @@per_page)
  end

  def profiles
    @profiles ||= postings.map(&:user).uniq.map{ |user| user.profile(current_site) }
  end

end
