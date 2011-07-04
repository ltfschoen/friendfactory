class Posting::LinksController < ApplicationController

  before_filter :require_user

  def create
    wave = current_site.waves.find_by_id(params[:wave_id])
    @posting = Posting::Link.new(params[:posting_link]).tap do |link|
      link.user = current_user
      link.state = :published
    end
    if wave && @posting.valid?
      wave.postings << @posting
      current_user.profile(current_site).postings << @posting
    end
    respond_to do |format|
      format.js { render :layout => false }
    end
  end

end
