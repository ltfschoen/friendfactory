require 'sass'

class Admin::SitesController < ApplicationController

  before_filter :require_admin, :except => [ :stylesheets ]

  helper_method :site, :page_title

  layout 'admin'

  def index
    @sites = Site.order('name asc')
    respond_to do |format|
      format.html
    end
  end

  def new
    @site = Site.new
    respond_to do |format|
      format.html
    end
  end

  def create
    respond_to do |format|
      if new_site.present?
        format.html { redirect_to admin_sites_path, :notice => "#{new_site.name} was successfully created" }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def edit
    @site = Site.find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  def update
    @site = Site.find(params[:id])
    respond_to do |format|
      if @site && @site.update_attributes(params[:site])
        format.html { redirect_to admin_sites_path, :notice => "#{@site.name} successfully updated" }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def stylesheets
    respond_to do |format|
      if site = Site.find_by_name(params[:site_name])
        variables = site.assets.type(Asset::Constant, Asset::Image).map(&:to_s)
        css = site.stylesheet(params[:controller_name])
        @engine = Sass::Engine.new((variables << css).compact.join, :syntax => :scss)
        format.css { render :text => @engine.render }
      else
        format.css { render :nothing => true }
      end
    end
  end

  private

  def site
    @site
  end

  def new_site
    @new_site ||= begin
      Site.transaction do
        site = Site.create!(params[:site])
        user_record = current_user_record.clone
        user_record.site = site
        personage = user_record.personages.build(:persona_attributes => { :type => 'Persona::Community', :handle => site.display_name, :emailable => true })
        user_record.save(:validate => false)
        site.update_attribute(:home_user, personage)
        site
      end
    end
  end

  def page_title
    "Site Administration"
  end

end
