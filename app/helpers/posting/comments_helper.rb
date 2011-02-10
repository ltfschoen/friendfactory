module Posting::CommentsHelper

  def render_comments(posting)
    content_tag(:ul, :class => 'posting_comments') do
      posting.children.comments.inject(String.new) do |buffer, comment|
        buffer << content_tag(:li) do
          render(:partial => 'posting/comments/comment', :object => comment)
        end
      end
    end <<
    render(:partial => 'posting/comments/new', :locals => { :parent => posting })
  end  
  
end