class CommentsController < ApplicationController
  
  before_filter :require_user
    
  def create
    posting = Posting::Base.find_by_id(params[:posting_id])
    if posting.present?
      @comment = Posting::Comment.new(params[:posting_comment])
      current_user.postings << @comment
      posting.children << @comment      
    end
    respond_to do |format|
      format.js
    end
  end
  
end
