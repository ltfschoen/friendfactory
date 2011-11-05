class Wave::CommunitiesController < ApplicationController

  DefaultWaveSlug = 'popular'

  before_filter :require_user

  layout 'community'

  cattr_reader :per_page
  @@per_page = 50

  helper_method :wave, :postings, :profiles

  def show
  end

  def rollcall
  end

  private

  def wave
    @wave ||= begin
      if params[:id]
        current_site.waves.published.find_by_id(params[:id])
      else
        current_site.home_wave
      end
    end
  end

  def postings
    @postings ||= wave.postings.published.includes(:user).order('sticky_until desc, updated_at desc').paginate(:page => params[:page], :per_page => @@per_page)
  end

  def profiles
    @profiles ||= postings.map(&:user).uniq.map{ |user| user.profile(current_site) }
  end

end
