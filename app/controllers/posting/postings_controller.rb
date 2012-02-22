class Posting::PostingsController < ApplicationController

  before_filter :require_user

  helper_method :posting, :page_title

  layout 'community'

  def show
    @posting = Posting::Base.site(current_site).find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  private

  def posting
    @posting
  end
  
  def page_title
    "#{current_site.display_name} - #{posting[:type].demodulize} Posting by #{posting.user.display_handle}"
  end

end
