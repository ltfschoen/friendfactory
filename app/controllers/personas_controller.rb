class PersonasController < ApplicationController

  extend ActiveSupport::Memoizable

  before_filter :require_user

  def photos
    @wave = Wave::Profile.find_by_id(params[:id])
    respond_to do |format|
      format.html { render :layout => false }
    end
  end

  private

  def persona
    Persona::Base.joins(:user).where(:users => { :site => current_site })
  end

end