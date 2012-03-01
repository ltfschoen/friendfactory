class Wave::PhotosController < ApplicationController

  extend ActiveSupport::Memoizable

  before_filter :require_user

  def show
    respond_to do |format|
      format.json { render :json => wave.photos.published }
    end
  end

  private

  def personage
    Personage.enabled.site(current_site).find(params[:profile_id])
  end

  def wave
    personage.find_or_create_photos_wave
  end

  memoize :personage, :wave

end