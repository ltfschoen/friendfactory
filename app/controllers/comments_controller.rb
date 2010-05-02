class CommentsController < ApplicationController
  
  before_filter :require_user
    
  def create
    @comment = nil
    posting  = Posting::Base.find_by_id(params[:posting_id])
    respond_to do |format|
      if posting
        @comment = Posting::Comment.new(params[:posting_comment])
        posting.children << @comment
        format.js
      else
        format.js
      end      
    end
  end
  
end