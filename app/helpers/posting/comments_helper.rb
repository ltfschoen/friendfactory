module Posting::CommentsHelper
  
  def render_comments(posting)
    String.new.html_safe.tap do |html|
      html.safe_concat(render_comments_list(posting))
      html.safe_concat(render_new_comment_form(posting))
    end
  end

  def link_to_comments(message, url)
    if message.is_a? Integer
      message = (message > 0 ? pluralize(message, 'comment') : 'Write a comment')
      message << '&nbsp;&rarr;'
    end
    content_tag(:span, :class => 'comments') do
      link_to message.html_safe, url, :remote => true, :class => 'comments'
    end
  end

  private

  def render_comments_list(posting)
    content_tag(:ul, :class => 'posting_comments') do
      String.new.html_safe.tap do |html|
        posting.children.comments.each { |comment| html.safe_concat(render_comment_list_item(comment)) }
      end
    end
  end
  
  def render_comment_list_item(comment)
    content_tag(:li, render(:partial => 'posting/comments/comment', :object => comment))
  end

  def render_new_comment_form(posting)
    render(:partial => 'posting/comments/new', :locals => { :posting => posting })
  end

  def link_to_new_comment(posting)
    link_to('New comment', new_posting_comment_path(posting), :class => 'new_posting_comment')
  end

end