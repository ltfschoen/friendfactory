class Posting::PhotosController < ApplicationController

  before_filter :require_user
  
  def create
    @wave ||= Wave::Base.find_by_id(params[:wave_id])
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
    @wave ||= Wave::Base.find_by_id(params[:wave_id])
    respond_to do |format|
      if posting.update_attributes(params[:posting_photo])
        posting.publish! if posting.state == :unpublished
        format.js { render :layout => false }
      end
    end
  end
  
  # def publish
  #   respond_to do |format|
  #     if posting.update_attributes(params[:posting_photo])
  #       posting.publish!
  #       format.js { render :layout => false }        
  #     end
  #   end
  # end
  
  def destroy
    raise params.inspect
  end

  private
  
  def posting
    @posting ||= Posting::Photo.find_by_id(params[:id])
  end

end
