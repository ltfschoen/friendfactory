class Admin::TagsController < ApplicationController

  before_filter :require_admin
  
  def index
    @tags = Admin::Tag.order('corrected asc, defective asc').all
    respond_to do |format|
      format.html
    end
  end

  def new
    @tag = Admin::Tag.new
    respond_to do |format|
      format.html
    end
  end

  def edit
    @tag = Admin::Tag.find(params[:id])
  end

  def create
    params[:admin_tag][:defective] = params[:admin_tag][:defective].strip
    params[:admin_tag][:corrected] = nil if params[:admin_tag][:corrected].length == 0
    @tag = Admin::Tag.new(params[:admin_tag].merge({:taggable_type => 'UserInfo'}))
    respond_to do |format|
      if @tag.save
        format.html { redirect_to(admin_tags_path, :notice => 'Tag was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @tag = Admin::Tag.find(params[:id])
    respond_to do |format|
      if @tag.update_attributes(params[:admin_tag])
        format.html { redirect_to(admin_tags_path, :notice => 'Tag was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @tag = Admin::Tag.find(params[:id])
    @tag.destroy
    respond_to do |format|
      format.html { redirect_to(admin_tags_url) }
    end
  end
  
  def commit
    Tag.refresh_all
    respond_to do |format|
      format.html { redirect_to(admin_tags_path, :notice => 'Changes committed.') }
    end
  end
  
end
