module Posting::CommentsHelper

  def render_comments(posting)    
    content_tag(:div, :class => 'posting_comments') do
      render(:partial => 'posting/comments/comment', :collection => posting.children.comments)
    end + 
    render(:partial => 'posting/comments/new', :locals => { :parent => posting })
  end
  
end