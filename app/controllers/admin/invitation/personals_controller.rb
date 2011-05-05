class Admin::Invitation::PersonalsController < ApplicationController

  before_filter :require_admin

  def index
    @waves = Wave::Invitation.find_all_by_site_and_fully_offered(current_site, params[:invites])
    respond_to do |format|
      format.html
    end
  end

end
