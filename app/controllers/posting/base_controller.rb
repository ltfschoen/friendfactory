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
        comments = posting.children.type(Posting::Comment).published.order('updated_at desc').limit(limit)
        comments.sort_by!{ |comment| comment.updated_at }.map! do |comment|
          profile = comment.user.profile(current_site)
          {
            :id         => comment.id,
            :posting_id => posting_id,
            :image_path => profile.avatar.url(:thumb),
            :handle     => profile.handle,
            :body       => comment.body,
            :updated_at => comment.updated_at
          }
        end
        { :id => posting_id, :comments => comments }
      end
    end
    # Rails.logger.info fetchables.inspect
    respond_to do |format|
      format.json { render :json => fetchables }
    end
  end

  def self.tag_helper
    TagHelper.instance
  end

  class TagHelper
    include Singleton
    # include ActionView::Helpers::TagHelper
    # include ActionView::Helpers::AssetTagHelper
  end

end