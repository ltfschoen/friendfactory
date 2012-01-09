class Wave::CommunitiesController < ApplicationController

  before_filter :require_user
  before_filter :redirect_to_home_wave, :only => [ :show ]

  helper_method :wave, :postings, :profiles, :tags

  helper_method :personages_on_wave
  helper_method :page_title

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

  # TODO Fix
  def tags
    @tags ||= profiles_on_wave.tag_counts_on(current_site).order('name asc').select{ |tag| tag.count > 1 }
  end

  def personages_on_wave(opts)
    @personages_on_wave ||= begin
      personage_ids = Posting::Base.select('distinct `postings`.`user_id`').joins(:waves).where(:waves => { :id => wave.id }).map(&:user_id)
      relation = Personage.includes(:persona).joins(:persona).where(:id => personage_ids).where('`personas`.`avatar_id` is not null')
      relation.limit(opts[:limit]) if opts[:limit]
      relation.all.reject{ |p| p.avatar.silhouette? }.uniq
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

  def redirect_to_home_wave
    # TODO Root path to be dynamic
    home_wave = current_site.home_wave
    if home_wave[:type] != 'Wave::Community'
      redirect_to url_for(home_wave)
    end
  end

  def page_title
    "#{current_site.display_name} - Community"
  end

end
