class Admin::Invitation::UniversalsController < ApplicationController

  before_filter :require_admin
  
  def index
    @postings = Posting::Invitation.offered.universal.site(current_site)
    respond_to do |format|
      format.html
    end
  end

end
