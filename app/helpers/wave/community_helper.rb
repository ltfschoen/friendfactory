module Wave::CommunityHelper

  def render_postings(postings, opts={})
    postings = [] if postings.nil?
    
    if opts[:only].present?
      postings = postings.select{ |posting| posting[:type] == opts[:only].to_s }
    end
    
    if opts[:exclude].present?
      postings = postings.reject{ |posting| posting[:type] == opts[:exclude].to_s }
    end

    rendered_post_its = render_post_its(postings)    
    postings = postings.reject{ |posting| posting[:type] == Posting::PostIt.name }
    number_of_breaks = (rendered_post_its.length > 0) ? rendered_post_its.length : 1

    String.new.html_safe.tap do |html|
      if postings.empty?
        html.safe_concat(rendered_post_its * '')
        html.safe_concat(content_tag(:ul, '', :class => 'postings clearfix'))
      else
        postings.in_groups(number_of_breaks) do |postings_in_break|          
          html.safe_concat(rendered_post_its.shift) unless rendered_post_its.empty?
          html.safe_concat(content_tag(:ul, :class => 'postings clearfix') do
            postings_in_break.inject(String.new.html_safe) do |buffer, posting|
              buffer.safe_concat(content_tag(:li, render(:partial => 'posting', :object => posting)))
            end
          end)
        end        
      end    
    end    
  end

  def render_post_its(postings)
    postings = postings.select{ |posting| posting[:type] == Posting::PostIt.name }
    postings.in_groups_of(5).map do |group|
      content_tag(:ul, :class => 'posting_post_its clearfix') do
        group.compact.inject(String.new.html_safe) do |buffer, posting|
          buffer.safe_concat(content_tag(:li) do
            render(:partial => 'posting/posting', :object => posting)
          end)
        end
      end
    end
  end

  def render_attachment(posting)
    render :partial => 'attachment', :locals => { :posting => posting }
  end
  
end