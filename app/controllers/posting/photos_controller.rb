class Posting::PhotosController < ApplicationController

  before_filter :require_user
  
  def new
    @wave = Wave::Base.find_by_id(params[:wave_id])
  end
  
  def create
    @wave = Wave::Base.find_by_id(params[:wave_id])
    if @wave.present?
      @posting = Posting::Photo.new(:image => params[:posting_photo][:image], :subject => params[:posting_photo][:subject]) do |photo|
        photo.user = current_user
      end
      @wave.postings << @posting
    end
    respond_to do |format|
      format.js { render :layout => false }
    end
  end

  def update
    @wave = Wave::Base.find_by_id(params[:wave_id])
    respond_to do |format|
      if posting.update_attributes(params[:posting_photo])
        posting.publish!
        format.js { render :layout => false }
      end
    end
  end
    
  def destroy
    posting.destroy
    respond_to do |format|
      format.js { render :layout => false }
    end
  end

  private
  
  def posting
    @posting ||= Posting::Photo.find_by_id(params[:id])
  end

end
