class SearchController < ApplicationController

  def index
    @postings  = Posting::Base.search params[:search], :with => { :private => 0 }
    @postings += Posting::Base.search params[:search], :with => { :private => 1, :recipient_ids => current_user.id }, :class => Posting::Message
    respond_to do |format|
      format.html 
    end
  end

end
