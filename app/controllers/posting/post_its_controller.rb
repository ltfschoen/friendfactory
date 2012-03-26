class Posting::PostItsController < ApplicationController

  before_filter :require_user

  def new
    @wave = Wave::Base.find_by_id(params[:wave_id])
  end

  def create
    wave = Wave::Base.find(params[:wave_id])
    add_posting_to_wave(new_post_it_posting, wave)
    respond_to do |format|
      format.js { render :layout => false }
    end
  end

  private

  def new_post_it_posting
    @posting ||= begin
      Posting::PostIt.new(params[:posting_post_it]) do |post_it|
        post_it.user = current_user
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
