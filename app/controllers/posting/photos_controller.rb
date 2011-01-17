class Posting::PhotosController < ApplicationController

  before_filter :require_user
  
  def create
    @wave = Wave::Base.find_by_id(params[:wave_id])
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
    # raise params.inspect
    @posting = Posting::Photo.find_by_id(params[:id])
    respond_to do |format|
      if @posting && @posting.update_attributes(params[:posting_photo])
        format.js { render :layout => false }
      end
    end
  end

end
