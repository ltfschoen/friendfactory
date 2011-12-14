class Wave::CommunitiesController < ApplicationController

  DefaultWaveSlug = 'popular'

  before_filter :require_user
  helper_method :wave, :postings, :profiles, :profiles_on_wave, :tags

  layout 'wave/community'

  cattr_reader :per_page

  def show
    @@per_page = 50
  end

  def rollcall
    @@per_page = 48
  end

  private

  def wave
    @wave ||= begin
      if params[:id].present?
        current_site.waves.published.find_by_id(params[:id])
      else
        current_site.home_wave
      end
    end
  end

  def postings
    @postings ||= wave.postings.published.includes(:user).
        order('sticky_until desc, updated_at desc').
        paginate(:page => params[:page], :per_page => @@per_page)
  end

  def profiles
    @profiles ||= profiles_with_tag.paginate(:page => params[:page], :per_page => @@per_page)
  end

  def tags
    @tags ||= profiles_on_wave.tag_counts_on(current_site).order('name asc').select{ |tag| tag.count > 1 }
  end

  def profiles_on_wave
    @profiles_on_wave ||= begin
      user_ids = wave.postings.published.map(&:user_id).uniq
      current_site.waves.type(Wave::Profile).where(:user_id => user_ids).scoped
    end
  end

  def profiles_with_tag
    @profiles_with_tag ||= begin
      profiles = profiles_on_wave
      profiles = profiles.tagged_with(scrub_tag(params[:tag]), :on => current_site) if params[:tag].present?
      profiles.scoped
    end
  end

  def scrub_tag(tag)
    tag.downcase.gsub(/-/, ' ')
  end

end
