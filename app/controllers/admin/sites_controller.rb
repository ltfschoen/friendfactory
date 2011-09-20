require 'sass'

class Admin::SitesController < ApplicationController

  before_filter :require_admin, :except => [ :stylesheets ]

  def index
    @sites = Site.order('name asc')
    respond_to do |format|
      format.html
    end
  end

  def new
    @site = Site.new
    @site.assets.build
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
    # Have empty assets ready for the form
    @site.images.build
    @site.constants.build
  end

  def update
    @site = Site.find(params[:id])
    respond_to do |format|
      if @site.update_attributes(params[:site])
        format.html { redirect_to admin_sites_path, :notice => "#{@site.name} successfully updated" }
      else
        format.html { render :action => "edit" }
      end
    end
  end
  
  def stylesheets
    # Stylesheet requests come in on assets hosts, so current_site
    # is not accurate. Use site name in the requested file:
    # http://<asset_host>.com/stylesheeets/<site>.css
    respond_to do |format|
      if site = Site.find_by_name(params[:site_name])      
        variables = site.assets.inject([]) do |memo, asset|
          memo << "$#{asset.name}:'#{asset.value}';" if asset.name.present?
          memo
        end
        @engine = Sass::Engine.new((variables << site.css).join, :syntax => :scss)
        format.css { render :text => @engine.render }
      else
        format.css { render :nothing => true }
      end
    end
  end

end
