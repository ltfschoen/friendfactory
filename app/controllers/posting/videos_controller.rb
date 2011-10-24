class Posting::VideosController < Posting::BaseController
  
  def create
    @posting = nil
    if @wave = current_site.waves.find_by_id(params[:wave_id])
      @posting = Posting::Video.new(params[:posting_video]) { |video| video.user = current_user }
      if @wave.postings << @posting
        @posting.publish!
      end
    end
    respond_to do |format|
      format.js { render :layout => false }
    end
  end
  
end
