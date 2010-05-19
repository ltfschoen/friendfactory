class PhotosController < ApplicationController

  before_filter :require_user
  
  def create
    wave = Wave::Base.find_by_id(params[:wave_id])
    if wave.present?
      @posting = Posting::Photo.create(params[:posting_photo])
      current_user.postings << @posting
      wave.postings << @posting
    end
    respond_to_parent do
      respond_to do |format|
        format.js
      end
    end    
  end
    
end
