class Posting::CommentsController < ApplicationController
  
  before_filter :require_user
    
  def create
    posting = Posting::Base.find_by_id(params[:posting_id])
    if posting.present?      
      @comment = Posting::Comment.new(:body => params[:posting_comment][:body], :user_id => current_user.id)
      posting.children << @comment      
    end
    respond_to do |format|
      format.js { render :layout => false }
    end
  end
  
end
