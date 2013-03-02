class Posting::CommentsController < ApplicationController

  before_filter :require_user
  after_filter :notify, :only => [ :create ]

  helper_method :posting, :comments, :comment

  def index
    respond_to do |format|
      posting_path = posting.class.name.underscore.pluralize
      format.html do
        render File.join(posting_path, 'comments'), :layout => false, :object => comments, :locals => { :posting => posting }
      end
    end
  end

  def new
    respond_to do |format|
      format.html { render :layout => false }
    end
  end

  def create
    respond_to do |format|
      posting.comments << comment
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
      posting.comments.published.order('"created_at" ASC')
    end
  end

  def comment
    @comment ||= begin
      Posting::Comment.user(current_user).published.new(params[:posting_comment])
    end
  end

  ###

  def notify
    if comment.persisted?
      posting.root.subscriptions.notify(:exclude => comment.user) do |subscriber|
        Posting::CommentsMailer.delay.create(subscriber, comment, current_site, request.host, request.port)
      end
    end
  end

end
