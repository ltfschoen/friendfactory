class Admin::SitesController < ApplicationController
  # GET /admin/sites
  # GET /admin/sites.xml
  def index
    @admin_sites = Admin::Site.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @admin_sites }
    end
  end

  # GET /admin/sites/1
  # GET /admin/sites/1.xml
  def show
    @admin_site = Admin::Site.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @admin_site }
    end
  end

  # GET /admin/sites/new
  # GET /admin/sites/new.xml
  def new
    @admin_site = Admin::Site.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @admin_site }
    end
  end

  # GET /admin/sites/1/edit
  def edit
    @admin_site = Admin::Site.find(params[:id])
  end

  # POST /admin/sites
  # POST /admin/sites.xml
  def create
    @admin_site = Admin::Site.new(params[:admin_site])

    respond_to do |format|
      if @admin_site.save
        format.html { redirect_to(@admin_site, :notice => 'Site was successfully created.') }
        format.xml  { render :xml => @admin_site, :status => :created, :location => @admin_site }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @admin_site.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin/sites/1
  # PUT /admin/sites/1.xml
  def update
    @admin_site = Admin::Site.find(params[:id])

    respond_to do |format|
      if @admin_site.update_attributes(params[:admin_site])
        format.html { redirect_to(@admin_site, :notice => 'Site was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @admin_site.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/sites/1
  # DELETE /admin/sites/1.xml
  def destroy
    @admin_site = Admin::Site.find(params[:id])
    @admin_site.destroy

    respond_to do |format|
      format.html { redirect_to(admin_sites_url) }
      format.xml  { head :ok }
    end
  end
end
