class Wave::WavesController < ApplicationController

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

end