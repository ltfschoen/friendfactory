require 'render_headshot'

class Wave::CommunitiesController < ApplicationController

  include RenderHeadshot

  before_filter :require_user

  # Show helpers
  helper_method \
      :wave,
      :paged_postings,
      :sidebar_rollcall

  # Rollcall helpers
  helper_method \
      :tags,
      :paged_rollcall

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
    @wave ||= begin
      if params[:id].present?
        current_site.waves.published.find(params[:id])
      else
        current_site.home_wave
      end
    end
  end

  def postings
    @postings ||= begin
      wave.postings.natural_order.published.joins(:user).merge(Personage.enabled).scoped
    end
  end

  def paged_postings
    @paged_postings ||= begin
      postings.includes(:user => { :persona => :avatar }).
          paginate(:page => params[:page], :per_page => @@per_page)
    end
  end

  def sidebar_rollcall
    @sidebar_rollcall ||= begin
      paged_postings.map(&:user).uniq.select { |user| user[:id] != wave[:user_id] }
    end
  end

  def paged_rollcall
    @paged_rollcall ||= begin
      rollcall = wave.rollcall.order('`postings`.`created_at` DESC').includes(:persona => :avatar).scoped
      rollcall = rollcall.joins(:persona).merge(Persona::Base.tagged_with(parameterize_tag(params[:tag]), :on => :tags)).scoped if params[:tag]
      rollcall.paginate(:page => params[:page], :per_page => @@per_page)
    end
  end

  def tags
    @tags ||= begin
      personas.tag_counts.order('`name` ASC').select{ |tag| tag.count > 1 }
    end
  end

  def personas
    @personas ||= begin
      user_ids = postings.map(&:user_id)
      Persona::Base.joins(:user).where(:personages => { :id => user_ids }).scoped
    end
  end

  ###

  def parameterize_tag(tag)
    tag.downcase.gsub(/-/, ' ')
  end

  def page_title
    "#{current_site.display_name} - #{wave.subject}"
  end

end
