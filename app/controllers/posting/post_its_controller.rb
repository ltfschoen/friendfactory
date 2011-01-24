class Posting::PostItsController < ApplicationController
  
  before_filter :require_user
  
  def new
    @wave = Wave::Base.find_by_id(params[:wave_id])
    @posting = Posting::PostIt.new(:user_id => current_user.id)
  end
  
  def create
    wave = Wave::Base.find_by_id(params[:wave_id])
    if wave.present?
      @posting = Posting::PostIt.new(:subject => params[:posting_post_it][:subject])
      @posting.user = current_user
      wave.postings << @posting
      @posting.publish!
    end    
    respond_to do |format|
      format.js { render :layout => false }
    end
  end

end
