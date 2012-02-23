class Posting::BaseController < ApplicationController

  before_filter :require_user

  def unpublish
    if @posting = Posting::Base.find_by_id(params[:id])
      if current_user.admin? || (current_user[:id] == @posting[:user_id])
        @posting.unpublish! rescue nil
      end
    end
    respond_to do |format|
      format.js { render :layout => false }
    end
  end

  def fetch
    fetchables = params[:id].to_a
    fetchables.map! do |posting_id, limit|
      if posting = Posting::Base.find_by_id(posting_id)
        comments = posting.comments.published.includes(:user => :profile).order('`updated_at` DESC').limit(limit)
        comments.map! do |comment|
          if profile = comment.user.profile
            { :id           => comment.id,
              :posting_id   => posting_id,
              :profile_path => url_for(profile),
              :image_path   => profile.avatar.url(:thimble),
              :handle       => profile.handle,
              :body         => tag_helper.truncate(comment.body, :length => 60),
              :updated_at   => tag_helper.distance_of_time_in_words_to_now(comment.updated_at) }
          else
            Rails.logger.warn("#{comment[:type]}:#{comment.id}@#{current_site.name} -- no profile")
            nil
          end
        end.compact!
        { :id => posting_id, :comments => comments }
      end
    end
    respond_to do |format|
      format.json { render :json => fetchables }
    end
  end

  private

  def tag_helper
    TagHelper.instance
  end

  class TagHelper
    include Singleton
    include ActionView::Helpers::TextHelper
    include ActionView::Helpers::DateHelper
  end

end