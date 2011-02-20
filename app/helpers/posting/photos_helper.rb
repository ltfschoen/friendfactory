module Posting::PhotosHelper

  def render_photo(photo, opts = {})
    return '&nbsp;'.html_safe unless photo.present?    
    css = [ 'photo', opts[:class] ].compact * ' '    
    if photo.horizontal?
      image_tag(photo.image.url(:h4x6), :site => false, :class => "#{css} h4x6")
    else
      image_tag(photo.image.url(:v4x6), :site => false, :class => "#{css} v4x6")
    end
  end

end