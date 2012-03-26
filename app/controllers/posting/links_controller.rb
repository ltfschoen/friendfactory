class Posting::LinksController < ApplicationController

  before_filter :require_user

  helper_method \
      :wave,
      :posting

  def create
    respond_to do |format|
      if posting.embedify && wave.postings << posting
        format.js { render :layout => false }
      else
        format.js { head :unprocessable_entity }
      end
    end
  end

  private

  def wave
    @wave ||= begin
      current_site.waves.find(params[:wave_id])
    end
  end

  def posting
    @posting ||= begin
      Posting::Link.published.new(params[:posting_link]) do |link|
        link.user = current_user
        link.sticky_until = params[:posting_link][:sticky_until] if current_user.admin?
      end
    end
  end

end
