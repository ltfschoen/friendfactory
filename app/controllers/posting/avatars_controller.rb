class Posting::AvatarsController < ApplicationController

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
    Posting::Base.site(current_site).find(params[:id])
  end

  def personage
    posting.user
  end

  memoize :posting, :personage

end