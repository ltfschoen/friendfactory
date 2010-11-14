class VideosController < ApplicationController
  
  before_filter :require_user
  
  def create
    params[:posting_video][:body].
            gsub!(/width="[[:digit:]]+"/, 'width="460"').
            gsub!(/height="[[:digit:]]+"/,'height="350"').
            gsub!(/fs=1/,'showinfo=0&fs=1')

    wave = Wave::Base.find_by_id(params[:wave_id])
    if wave.present?
      @posting = Posting::Video.create(params[:posting_video])
      current_user.postings << @posting
      wave.postings << @posting
    end
    respond_to do |format|      
      format.js
    end
  end
  
end
