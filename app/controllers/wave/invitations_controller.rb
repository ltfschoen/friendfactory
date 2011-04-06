class Wave::InvitationsController < ApplicationController
  
  before_filter :require_user
  
  def index
    @wave = current_user.find_or_create_invitation_wave(current_site)
    @invitation_postings = @wave.postings.type(Posting::Invitation).limit(Wave::InvitationsHelper::MaximumDefaultImages)
    respond_to do |format|
      format.html
    end
  end
  
end
