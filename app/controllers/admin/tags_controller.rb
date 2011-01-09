class Admin::TagsController < ApplicationController

  before_filter :require_admin
  
  def index
    @admin_tags = Admin::Tag.all
    respond_to do |format|
      format.html
    end
  end

  # GET /admin/tags/1
  # GET /admin/tags/1.xml
  def show
    @admin_tag = Admin::Tag.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @admin_tag }
    end
  end

  # GET /admin/tags/new
  # GET /admin/tags/new.xml
  def new
    @admin_tag = Admin::Tag.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @admin_tag }
    end
  end

  # GET /admin/tags/1/edit
  def edit
    @admin_tag = Admin::Tag.find(params[:id])
  end

  # POST /admin/tags
  # POST /admin/tags.xml
  def create
    @admin_tag = Admin::Tag.new(params[:admin_tag])

    respond_to do |format|
      if @admin_tag.save
        format.html { redirect_to(@admin_tag, :notice => 'Tag was successfully created.') }
        format.xml  { render :xml => @admin_tag, :status => :created, :location => @admin_tag }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @admin_tag.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin/tags/1
  # PUT /admin/tags/1.xml
  def update
    @admin_tag = Admin::Tag.find(params[:id])

    respond_to do |format|
      if @admin_tag.update_attributes(params[:admin_tag])
        format.html { redirect_to(@admin_tag, :notice => 'Tag was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @admin_tag.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/tags/1
  # DELETE /admin/tags/1.xml
  def destroy
    @admin_tag = Admin::Tag.find(params[:id])
    @admin_tag.destroy

    respond_to do |format|
      format.html { redirect_to(admin_tags_url) }
      format.xml  { head :ok }
    end
  end
end
