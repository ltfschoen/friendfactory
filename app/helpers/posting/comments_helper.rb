module Posting::CommentsHelper
  
  def render_comments(posting)
    String.new.html_safe.tap do |html|
      html.safe_concat(render_comments_ul(posting))
      html.safe_concat(link_to_new_comment(posting))
    end
  end
  
  def render_comments_ul(posting)
    content_tag(:ul, :class => 'posting_comments') do
      String.new.html_safe.tap do |html|
        posting.children.comments.each { |comment| html.safe_concat(render_comment_li(comment)) }
      end
    end
  end

  private
  
  def render_comment_li(comment)
    content_tag(:li, render(:partial => 'posting/comments/comment', :object => comment))
  end
    
  def link_to_new_comment(posting)
    link_to('New comment', new_posting_comment_path(posting), :class => 'new_posting_comment')
  end
    
end