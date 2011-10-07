class Posting::CommentsController < ApplicationController
  
  before_filter :require_user

  def index
    @postings = []
    if posting = Posting::Base.find_by_id(params[:posting_id])
      @postings = posting.children.published.order('updated_at desc')
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
    posting = Posting::Base.find_by_id(params[:posting_id])
    if posting.present?      
      @comment = new_posting_comment
      posting.children << @comment
      @comment.publish!
    end
    respond_to do |format|
      format.js { render :layout => false }
    end
  end
  
  private
  
  def new_posting_comment
    Posting::Comment.new(:body => params[:posting_comment][:body]).tap do |posting|
      posting.user = current_user
    end    
  end
  
end
