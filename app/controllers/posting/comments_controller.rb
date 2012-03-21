class Posting::CommentsController < ApplicationController

  before_filter :require_user

  helper_method \
      :posting,
      :comments,
      :posting_type

  def index
    respond_to do |format|
      posting_path = posting.class.name.underscore.tableize
      format.html { render File.join(posting_path, 'comments'), :layout => false, :object => comments, :locals => { :posting => posting }}
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

  def posting
    @posting ||= begin
      Posting::Base.find(params[:posting_id])
    end
  end

  def comments
    @comments ||= begin
      posting.comments.published.order('`updated_at` DESC')
    end
  end

  ###

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
      PostingsMailer.delay.new_comment_notification(comment, recipient, current_site, request.host, request.port)
    end
  end

end
