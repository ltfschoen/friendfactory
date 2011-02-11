module Wave::BaseHelper

  def render_postings(postings, opts={})
    if opts[:only].present?
      postings = postings.select{ |posting| posting[:type] == opts[:only].to_s }
    end
    
    if opts[:exclude].present?
      postings = postings.reject{ |posting| posting[:type] == opts[:exclude].to_s }
    end

    content_tag(:ul, :class => opts[:class]) do
      postings.inject(String.new) do |buffer, posting|
        buffer << content_tag(:li) do
          render(:partial => 'posting/posting', :object => posting)
        end        
      end
    end
  end
  
end