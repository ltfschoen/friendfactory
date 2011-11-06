class Posting::AvatarsController < ApplicationController

  before_filter :require_user

  def comments
    @comments = []
    if @posting = Posting::Base.find_by_id(params[:id])
      @profile = @posting.user.profile(current_site)
      @comments = @posting.comments.published.order('updated_at desc')
    end
    respond_to do |format|
      format.html { render :layout => false }
    end    
  end

end