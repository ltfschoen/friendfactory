require 'sass'

class Admin::SitesController < ApplicationController

  before_filter :require_admin, :except => [ :stylesheets ]
  helper_method :site, :page_title

  layout 'admin/site'

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
    @site = Site.new(params[:site])
    respond_to do |format|
      if @site.save
        format.html { redirect_to admin_sites_path, :notice => "#{@site.name} was successfully created" }
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
    # Stylesheet requests come in on assets hosts, so current_site
    # is not accurate. Use site name in the requested file:
    # http://<asset_host>.com/stylesheeets/<site>/<controller>.css
    respond_to do |format|
      if site = Site.find_by_name(params[:site_name])
        variables = site.assets.type(Asset::Constant, Asset::Image).map(&:to_s)
        css = site.stylesheet(params[:controller_name])
        @engine = Sass::Engine.new((variables << css << uid_css).compact.join, :syntax => :scss)
        format.css { render :text => @engine.render }
      else
        format.css { render :nothing => true }
      end
    end
  end

  private

  def uid_css
    if current_user
      <<-EOF
        body.#{current_user.uid} .post.#{current_user.uid}:hover .remove { opacity: 1; }
        .ie8 body.#{current_user.uid} .post.#{current_user.uid}:hover .remove { visibility: visible; }
      EOF
    end
  end

  def site
    @site
  end

  def page_title
    "Site Administration"
  end

end
