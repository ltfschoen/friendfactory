class Wave::InvitationsController < ApplicationController
  
  before_filter :require_user
  
  def index
    @wave = current_user.invitation_wave(current_site) || new_invitation_wave    
    @invitation_postings = @wave.postings.type(Posting::Invitation).limit(Wave::InvitationsHelper::MaximumDefaultImages)
    respond_to do |format|
      format.html
    end
  end
  
  private
  
  def new_invitation_wave
    Wave::Invitation.new.tap do |wave|
      wave.user = current_user
      wave.site = current_site
    end
  end  
  
end
