class Posting::VideosController < Posting::BaseController
  
  def create
    @posting = Posting::Video.new(params[:posting_video]).tap { |video| video.user = current_user }
    if @posting.valid? && @wave = current_site.waves.find_by_id(params[:wave_id])
      @wave.postings << @posting
      @posting.publish!
    end
    respond_to do |format|      
      format.js { render :layout => false }
    end
  end
  
end
