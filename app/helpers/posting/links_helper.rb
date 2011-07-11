module Posting::LinksHelper
  
  def render_embed(embed)
    case embed.type.try(:to_sym)
    when :photo then image_tag(embed.url)
    else embed.html.html_safe
    end
  end
      
end