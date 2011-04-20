class Posting::CommentsController < ApplicationController
  
  before_filter :require_user

  def new
    @posting = Posting::Base.find_by_id(params[:posting_id])
    respond_to do |format|
      format.html { render :layout => false }
    end
  end
  
  def create
    posting = Posting::Base.find_by_id(params[:posting_id])
    if posting.present?      
      @comment = Posting::Comment.new(:body => params[:posting_comment][:body], :user_id => current_user.id)
      posting.children << @comment
      @comment.publish!
    end
    respond_to do |format|
      format.js { render :layout => false }
    end
  end
  
end
