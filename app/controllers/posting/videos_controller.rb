class Posting::VideosController < ApplicationController
  
  before_filter :require_user
  
  def create
    @posting = Posting::Video.new(params[:posting_video]).tap { |video| video.user = current_user }
    if @wave = current_site.waves.find_by_id(params[:wave_id]) && @posting.valid?
      @wave.postings << @posting
    end
    respond_to do |format|      
      format.js { render :layout => false }
    end
  end
  
end
