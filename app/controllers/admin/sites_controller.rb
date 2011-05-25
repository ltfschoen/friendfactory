class Admin::SitesController < ApplicationController

  before_filter :require_admin

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

  def edit
    @site = Site.find(params[:id])
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

end
