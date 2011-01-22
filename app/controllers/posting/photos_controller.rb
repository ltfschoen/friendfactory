class Posting::PhotosController < ApplicationController

  before_filter :require_user
  before_filter :find_wave_by_id
  
  def create
    if @wave.present?      
      @posting = Posting::Photo.new(:image => params[:posting_photo][:image], :subject => params[:posting_photo][:subject])
      @posting.user = current_user
      @wave.postings << @posting
    end    
    respond_to do |format|
      format.js { render :layout => false }
    end
  end

  def update
    respond_to do |format|
      if posting.update_attributes(params[:posting_photo])
        format.js { render :layout => false }
      end
    end
  end
  
  def publish
    respond_to do |format|
      if posting.update_attributes(params[:posting_photo])
        posting.publish!
        format.js { render :layout => false }        
      end
    end
  end
  
  def destroy
    raise params.inspect
  end

  private
  
  def find_wave_by_id
    @wave ||= Wave::Base.find_by_id(params[:wave_id])    
  end
  
  def posting
    @posting ||= Posting::Photo.find_by_id(params[:id])
  end

end
