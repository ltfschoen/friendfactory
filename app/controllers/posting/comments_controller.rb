class Posting::CommentsController < ApplicationController

  before_filter :require_user

  helper_method \
      :posting,
      :comments,
      :comment

  def index
    respond_to do |format|
      posting_path = posting.class.name.underscore.tableize
      wave = params[:wave_id].present? ? Wave::Base.find_by_id(params[:wave_id]) : nil
      format.html { render File.join(posting_path, 'comments'), :layout => false, :object => comments, :locals => { :posting => posting, :wave => wave }}
    end
  end

  def new
    respond_to do |format|
      format.html { render :layout => false }
    end
  end

  def create
    respond_to do |format|
      if posting.children << comment
        comment.publish! && broadcast
        format.js { render :layout => false }
      else
        format.js { head :unprocessable_entity }
      end
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

  def comment
    @comment ||= begin
      Posting::Comment.new(params[:posting_comment]) do |comment|
        comment.user = current_user
      end
    end
  end

  ###

  def broadcast
    recipient = posting.user
    if (recipient.offline? && recipient.emailable?) || Rails.env.development?
      PostingsMailer.delay.new_comment_notification(comment, recipient, current_site, request.host, request.port)
    end
  end

end
