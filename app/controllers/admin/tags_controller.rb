class Admin::TagsController < ApplicationController

  before_filter :require_admin
  
  def index
    @tags = Admin::Tag.all
    respond_to do |format|
      format.html
    end
  end

  def show
    @tag = Admin::Tag.find(params[:id])
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
    @tag = Admin::Tag.new(params[:admin_tag].merge({:taggable_type => 'UserInfo'}))
    respond_to do |format|
      if @tag.save
        refresh_user_info
        format.html { redirect_to(@tag, :notice => 'Tag was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @tag = Admin::Tag.find(params[:id])
    respond_to do |format|
      if @tag.update_attributes(params[:admin_tag])
        refresh_user_info
        format.html { redirect_to(@tag, :notice => 'Tag was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @tag = Admin::Tag.find(params[:id])
    @tag.destroy
    refresh_user_info
    respond_to do |format|
      format.html { redirect_to(admin_tags_url) }
    end
  end
  
  private

  def refresh_user_info
    UserInfo.all.each { |user_info| user_info.touch && user_info.save! }
    ActsAsTaggableOn::Tag.all.select{ |t| t.taggings.empty? }.each{ |t| t.delete }
  end
  
end
