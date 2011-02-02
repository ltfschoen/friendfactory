class Posting::VideosController < ApplicationController
  
  before_filter :require_user
  
  helper_method :wave, :valid_url?
  
  def create
    if wave && valid_url?(params[:posting_video][:body])
      @posting = Posting::Video.create(params[:posting_video])
      @posting.user = current_user
      wave.postings << @posting
      @posting.publish!
    end
    respond_to do |format|      
      format.js { render :layout => false }
    end
  end
  
  private
  
  def valid_url?(url = nil)
    @valid_url ||= (youtube_url?(url) && youtube_vid?(url))
  end
  
  def youtube_url?(url)    
    /^(http:\/\/)?(www\.)?youtube\.com/.match(url.strip).present?    
  end
  
  def youtube_vid?(url)
    results = /[\\?&]v=([^&#]*)/.match(url)
    results.present? && (results[1].length == 11)
  end
  
  def wave
    @wave ||= Wave::Base.find_by_id(params[:wave_id])
  end  
  
end
