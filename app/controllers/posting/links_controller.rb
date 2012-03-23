class Posting::LinksController < ApplicationController

  def create
    wave = current_site.waves.find(params[:wave_id])
    add_posting_to_wave(new_link_posting, wave)
    new_link_posting.reload
    respond_to do |format|
      format.js { render :layout => false }
    end
  end

  private

  def new_link_posting
    @posting ||= begin
      Posting::Link.new(params[:posting_link]) do |link|
        link.site = current_site
        link.user = current_user
        link.sticky_until = params[:posting_link][:sticky_until] if current_user.admin?
        link.embedify
      end
    end
  end

  def add_posting_to_wave(posting, wave)
    ActiveRecord::Base.transaction do
      if wave.postings << posting
        posting.publish!
      end
    end
  end

end
