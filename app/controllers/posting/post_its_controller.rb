class Posting::PostItsController < ApplicationController
  
  before_filter :require_user
  
  def create
    wave = Wave::Base.find_by_id(params[:wave_id])
    if wave.present?
      @posting = Posting::PostIt.new(:subject => params[:posting_post_it][:subject], :user_id => current_user.id)      
      wave.postings << @posting
    end    
    respond_to do |format|
      format.js { render :layout => false }
    end
  end

end
