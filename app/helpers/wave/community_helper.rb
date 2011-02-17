module Wave::CommunityHelper

  def render_postings(postings, opts={})
    return unless postings.present?
    
    if opts[:only].present?
      postings = postings.select{ |posting| posting[:type] == opts[:only].to_s }
    end
    
    if opts[:exclude].present?
      postings = postings.reject{ |posting| posting[:type] == opts[:exclude].to_s }
    end

    rendered_post_its = render_post_its(postings)
    postings = postings.reject{ |posting| posting[:type] == Posting::PostIt.name }
    number_of_breaks = (rendered_post_its.length > 0) ? rendered_post_its.length : postings.length    

    String.new.html_safe.tap do |html|      
      postings.in_groups(number_of_breaks) do |postings_in_break|
        html.safe_concat(rendered_post_its.shift) unless rendered_post_its.empty?
        html.safe_concat(content_tag(:ul, :class => 'postings clearfix') do
          postings_in_break.inject(String.new.html_safe) do |buffer, posting|
            buffer.safe_concat(content_tag(:li) do
              render(:partial => 'posting/posting', :object => posting)
            end)
          end
        end)
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
  
end