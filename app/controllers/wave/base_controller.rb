class Wave::BaseController < ApplicationController

  before_filter :require_user

  def unpublish
    wave = current_site.waves.find_by_id(params[:id])
    if wave && (current_user.admin? || (current_user.id == wave.user_id))
      wave.unpublish! rescue nil
    end
    respond_to do |format|
      format.json { render :json => { :success => true }}
    end
  end

  private

  def render_headshot(profile_id, opts = {})
    if personage = Personage.enabled.site(current_site).includes(:persona => :avatar).find_by_profile_id(profile_id)
      render :partial => File.join('personages', personage.persona_type, 'headshot'), :locals => { :personage => personage }.merge(opts)
    end
  end

end