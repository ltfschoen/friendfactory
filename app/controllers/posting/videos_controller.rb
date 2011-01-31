class Posting::VideosController < ApplicationController
  
  before_filter :require_user
  
  def create
    wave = Wave::Base.find_by_id(params[:wave_id])
    if wave.present?
      @posting = Posting::Video.create(params[:posting_video])
      @posting.user = current_user
      wave.postings << @posting
      @posting.publish!
    end
    respond_to do |format|      
      format.js { render :layout => false }
    end
  end
  
end
