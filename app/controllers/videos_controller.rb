class VideosController < ApplicationController
  
  before_filter :require_user
  
  def create
    params[:posting_video][:body].
            gsub!(/width="[[:digit:]]+"/, 'width="460"').
            gsub!(/height="[[:digit:]]+"/,'height="350"').
            gsub!(/fs=1/,'showinfo=0&fs=1')

    #.gsub(/height=".+"/, 'height="350"').gsub(/fs=1/, 'showinfo=0&fs=1')
    
    # raise params.inspect
    wave = Wave::Base.find_by_id(params[:wave_id])
    @posting = Posting::Video.create(params[:posting_video].merge({:user_id => current_user, :wave_id => wave})) if wave.present?    
    respond_to do |format|      
      format.js
    end
  end
  
end
