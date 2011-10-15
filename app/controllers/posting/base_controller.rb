class Posting::BaseController < ApplicationController

  before_filter :require_user

  def unpublish
    if @posting = Posting::Base.find_by_id(params[:id])
      if current_user.admin? || (current_user[:id] == @posting[:user_id])
        @posting.unpublish! rescue nil
      end
    end
    respond_to do |format|
      format.js { render :layout => false }
    end
  end

end