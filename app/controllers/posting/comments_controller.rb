class Posting::CommentsController < ApplicationController

  before_filter :require_user

  def index
    @comments = []
    if @posting = Posting::Base.find_by_id(params[:posting_id])
      @comments = @posting.comments.published.order('updated_at desc')
    end
    respond_to do |format|
      format.html { render :layout => false }
    end
  end

  def new
    @posting = Posting::Base.find_by_id(params[:posting_id])
    respond_to do |format|
      format.html { render :layout => false }
    end
  end

  def create
    @posting = Posting::Base.find(params[:posting_id])
    @comment = add_comment_to_posting(new_comment, @posting)
    broadcast_posting(@comment, @posting.user) if @comment.present?
    respond_to do |format|
      format.js { render :layout => false }
    end
  end

  private

  def new_comment
    Posting::Comment.new(params[:posting_comment]) do |comment|
      comment.user = current_user
    end
  end

  def add_comment_to_posting(comment, posting)
    ActiveRecord::Base.transaction do
      posting.children << comment
      comment.publish!
      comment
    end
  end

  def broadcast_posting(comment, recipient)
    if (recipient.offline? && recipient.emailable?) || Rails.env.development?
      PostingsMailer.new_comment_notification(comment, recipient, current_site, request.host, request.port).deliver
    end
  end

end
