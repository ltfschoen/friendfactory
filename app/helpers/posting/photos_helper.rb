module Posting::PhotosHelper

  def render_photo(photo)
    return '&nbsp;'.html_safe unless photo.present?
    if photo.horizontal?
      image_tag(photo.image.url(:h4x6), :site => false, :class => 'photo h4x6 small')
    else
      image_tag(photo.image.url(:v4x6), :site => false, :class => 'photo v4x6 small')
    end
  end

end