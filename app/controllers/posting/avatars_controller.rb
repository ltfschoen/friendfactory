class Posting::AvatarsController < ApplicationController

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
    @posting ||= begin
      Posting::Base.site(current_site).find(params[:id])
    end
  end

  def personage
    @personage ||= begin
      personage = Personage.includes(:persona => :avatar).find(posting[:user_id])
      personage.persona.avatar = posting
      personage
    end
  end

end