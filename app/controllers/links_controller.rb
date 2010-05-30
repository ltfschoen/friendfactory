class LinksController < WavesController

  before_filter :require_user

  def create
    wave = Wave::Base.find_by_id(params[:wave_id])    
    if wave.present?
      @posting = Posting::Link.create(params[:posting_link]) 
      wave.postings << @posting
    end
    respond_to do |format|      
      format.js
    end
  end

end
