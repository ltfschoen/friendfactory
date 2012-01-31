class Admin::InvitationsController < ApplicationController

  extend ActiveSupport::Memoizable

  before_filter :require_admin

  helper_method :site, :invitations
  helper_method :page_title

  layout 'admin'

  def index
    respond_to do |format|
      format.html
    end
  end
  
  def update
    
    raise params.inspect
  end

  private

  def site
    Site.find(params[:site_id])
  end

  def invitations
    # ::Invitation::Base.site(current_site)
    site.invitations
  end

  def invitation
    invitations.find(params[:id])
  end

  memoize :site, :invitations, :invitation

  def page_title
    "Site Administration - Invitations"
  end

end
