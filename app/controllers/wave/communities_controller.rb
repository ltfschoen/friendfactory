require 'render_headshot'

class Wave::CommunitiesController < ApplicationController

  include RenderHeadshot

  extend ActiveSupport::Memoizable

  before_filter :require_user

  helper_method :wave, :postings, :paged_users, :profiles, :tags
  helper_method :page_title

  layout 'three-column'

  cattr_reader :per_page

  def show
    @@per_page = 50
    @users_on_wave = Personage.wave(wave).limit(30)
    respond_to do |format|
      format.html { request.xhr? ? render_headshot(params[:id]) : render }
    end
  end

  def rollcall
    @@per_page = 48
    respond_to do |format|
      format.html
    end
  end

  private

  def wave
    if params[:id].present?
      current_site.waves.published.find_by_id(params[:id])
    else
      current_site.home_wave
    end
  end

  memoize :wave

  def postings
    wave.postings.published.
      includes(:user => { :persona => :avatar }).
      order('`sticky_until` DESC, `updated_at` DESC').
      paginate(:page => params[:page], :per_page => @@per_page)
  end

  memoize :postings

  def paged_users
    Personage.where(:profile_id => profiles.map(&:id)).paginate(:page => params[:page], :per_page => @@per_page)
  end

  memoize :paged_users

  def tags
    profiles_on_wave.tag_counts_on(current_site).order('name asc').select{ |tag| tag.count > 1 }
  end

  memoize :tags

  ###

  def users_on_wave
    Personage.enabled.wave(wave).all
  end

  def profiles_on_wave
    profile_ids = users_on_wave.map(&:profile_id)
    current_site.waves.where(:id => profile_ids).scoped
  end

  def profiles
    profiles = profiles_on_wave
    profiles = profiles.tagged_with(scrub_tag(params[:tag]), :on => current_site).scoped if params[:tag].present?
    profiles.scoped
  end

  def scrub_tag(tag)
    tag.downcase.gsub(/-/, ' ')
  end

  def page_title
    "#{current_site.display_name} - #{wave.subject}"
  end

end
