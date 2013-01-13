module Posting
  class VideosController < ApplicationController
    def create
      @posting = nil
      if @wave = current_site.waves.find_by_id(params[:wave_id])
        @posting = Posting::Video.new(params[:posting_video]) do |video|
          video.user = current_user
        end
        if @wave.postings << @posting
          @posting.publish!
        end
      end
      respond_to do |format|
        format.js { render :layout => false }
      end
    end
  end
end
