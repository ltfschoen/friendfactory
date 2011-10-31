class Wave::InvitationsController < ApplicationController

  before_filter :require_user
  helper_method :page_title
  layout 'invitation'

  def index
    @wave = current_user.find_or_create_invitation_wave_for_site(current_site)
    @invitation_postings = @wave.postings.type(Posting::Invitation).order('created_at asc').limit(default_images_count)
    respond_to do |format|
      format.html
    end
  end

  private
  
  def page_title
    "#{current_site.display_name} Invitations"
  end

  def default_images_count
    Wave::InvitationsHelper::MaximumDefaultImages
  end

end
