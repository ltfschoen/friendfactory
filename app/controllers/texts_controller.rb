class TextsController < ApplicationController
  
  before_filter :require_user
  
  def create
    wave = Wave::Base.find_by_id(params[:wave_id])
    if wave.present?
      @posting = Posting::Text.new(params[:posting_text])
      current_user.postings << @posting
      wave.postings << @posting
    end    
    respond_to do |format|
      format.js { render :layout => false }
    end
  end

end
