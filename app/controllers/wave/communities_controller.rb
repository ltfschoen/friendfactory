require 'render_headshot'

class Wave::CommunitiesController < ApplicationController

  include RenderHeadshot

  extend ActiveSupport::Memoizable

  before_filter :require_user

  # Show helpers
  helper_method \
      :wave,
      :paged_postings,
      :users_from_paged_postings_excluding_wave_owner

  # Rollcall helpers
  helper_method \
      :tags,
      :paged_users_from_tagged_personas

  helper_method :page_title

  layout 'community'

  cattr_reader :per_page
  @@per_page = 50

  def show
    respond_to do |format|
      format.html { request.xhr? ? render_headshot(params[:id]) : render }
    end
  end

  def rollcall
    respond_to do |format|
      format.html { render :layout => 'rollcall' }
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

  def paged_postings
    postings.
      includes(:user => { :persona => :avatar }).
      paginate(:page => params[:page], :per_page => @@per_page)
  end

  def users_from_paged_postings_excluding_wave_owner
    paged_postings.map(&:user).uniq.select { |user| user[:id] != wave[:user_id] }
  end

  memoize :wave, :paged_postings, :users_from_paged_postings_excluding_wave_owner

  ###

  def tags
    personas.tag_counts.order('`name` ASC').select{ |tag| tag.count > 1 }
  end

  def paged_users_from_tagged_personas
    Personage.
      includes(:persona => :avatar ).
      where(:persona_id => tagged_personas.map(&:id)).
      paginate(:page => params[:page], :per_page => @@per_page)
  end

  memoize :tags, :paged_users_from_tagged_personas

  ###

  def tagged_personas
    tagged_personas = personas
    tagged_personas = personas.tagged_with(parameterize_tag(params[:tag]), :on => :tags).scoped if params[:tag]
    tagged_personas
  end

  def personas
    user_ids = postings.map(&:user_id)
    Persona::Base.joins(:user).where(:personages => { :id => user_ids }).scoped
  end

  def postings
    wave.postings.natural_order.published.joins(:user).merge(Personage.enabled).scoped
  end

  def parameterize_tag(tag)
    tag.downcase.gsub(/-/, ' ')
  end

  def page_title
    "#{current_site.display_name} - #{wave.subject}"
  end

end
