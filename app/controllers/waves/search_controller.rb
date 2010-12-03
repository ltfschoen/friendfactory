class Waves::SearchController < ApplicationController

  before_filter :require_lurker

  def index
    postings = Posting::Base.search params[:search], :with => { :private => 0 }
    # postings += Posting::Base.search params[:search], :with => { :private => 1, :recipient_ids => current_user.id }, :classes => [ Posting::Message ]
    @wave = Wave::Search.new(params[:search], postings)
    respond_to do |format|
      format.html { render :action => 'show' }
    end
  end

end
