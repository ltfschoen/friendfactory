require 'render_headshot'

class Wave::ProfilesController < ApplicationController

  include RenderHeadshot

  extend ActiveSupport::Memoizable

  before_filter :require_user

  helper_method :wave, :postings, :profile
  helper_method :page_title

  layout 'community'

  cattr_reader :per_page

  # def index
  #   @@per_page = 102
  #   @waves = find_profiles_tagged_with(params[:tag]) || find_all_profiles
  #   @tags = tag_counts_for_current_site
  #   respond_to do |format|
  #     format.html
  #   end
  # end

  def show
    @@per_page = 50
    respond_to do |format|
      format.html { request.xhr? ? render_headshot(params[:id]) : render }
    end
  end

  private

  def find_profiles_tagged_with(tag)
    return unless tag.present?
    Wave::Profile.tagged_with(scrubbed_tag(tag), :on => current_site).
        where(:state => :published).
        order('updated_at desc').
        paginate(:page => params[:page], :per_page => @@per_page)
  end

  def find_all_profiles
    current_site.waves.
        type(Wave::Profile).
        where(:state => :published).
        order('updated_at desc').
        paginate(:page => params[:page], :per_page => @@per_page)
  end

  def tag_counts_for_current_site
    Wave::Profile.tag_counts_on(current_site).order('name asc')
  end

  def scrubbed_tag(tag)
    tag.downcase.gsub(/-/, ' ')
  end

  ###

  def wave
    current_site.waves.published.type(Wave::Profile).find(params[:id])
  end

  memoize :wave

  alias :profile :wave

  def postings
    wave.postings.published.order('updated_at desc').paginate(:page => params[:page], :per_page => @@per_page)
  end

  memoize :postings

  def page_title
    "#{current_site.display_name} - #{wave.user.handle}"
  end

  memoize :page_title

end
