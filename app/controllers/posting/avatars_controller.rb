class Posting::AvatarsController < ApplicationController

  before_filter :require_user

  def comments
    @posting = Posting::Base.site(current_site).find(params[:id])
    @comments = @posting.comments.published.order('updated_at desc')
    @personage = @posting.user
    respond_to do |format|
      format.html { render :layout => false }
    end
  end

end