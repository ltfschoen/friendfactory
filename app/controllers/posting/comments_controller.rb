class Posting::CommentsController < ApplicationController

  before_filter :require_user

  def index
    @posting = Posting::Base.site(current_site).find(params[:posting_id])
    @comments = @posting.comments.published.order('updated_at desc')
    respond_to do |format|
      format.html { render :layout => false }
    end
  end

  def new
    @posting = Posting::Base.find(params[:posting_id])
    respond_to do |format|
      format.html { render :layout => false }
    end
  end

  def create
    @posting = Posting::Base.find(params[:posting_id])
    if add_comment_to_posting(new_comment, @posting)
      broadcast_posting(new_comment, @posting)
    end
    respond_to do |format|
      format.js { render :layout => false }
    end
  end

  private

  def new_comment
    @comment ||= begin
      Posting::Comment.new(params[:posting_comment]) do |comment|
        comment.user = current_user
      end
    end
  end

  def add_comment_to_posting(comment, posting)
    not ActiveRecord::Base.transaction do
      if posting.children << comment
        comment.publish!
      end
    end.nil?
  end

  def broadcast_posting(comment, parent)
    recipient = parent.user
    if (recipient.offline? && recipient.emailable?) || Rails.env.development?
      PostingsMailer.new_comment_notification(comment, recipient, current_site, request.host, request.port).deliver
    end
  end

end
