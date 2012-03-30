module Posting::PhotosHelper

  def render_photo(photo, opts = {})
    return '&nbsp;'.html_safe unless photo.present?
    css_class = [ 'photo', photo.orientation, opts[:class] ].compact.join(' ')
    image_tag(photo.image_path, :site => false, :class => css_class)
  end

end