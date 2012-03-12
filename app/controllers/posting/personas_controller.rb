class Posting::PersonasController < ApplicationController

  extend ActiveSupport::Memoizable

  before_filter :require_user

  helper_method \
      :posting,
      :personage

  def comments
    respond_to do |format|
      format.html { render :layout => false }
    end
  end

  private

  def posting
    Posting::Persona.site(current_site).published.find(params[:id])
  end

  def personage
    Personage.includes(:persona => :avatar).enabled.find(posting[:user_id])
  end

  memoize :posting, :personage

end