module Posting::AvatarsHelper
  
  def thumb_avatar_image_tag(avatar, opts)
    image_tag avatar.url(:thumb), wave_profile_path(avatar.profile(current_site)), :size => '32x32'
  end
  
  def placeholder_image_tag(opts = {})
    css_class = [ 'placeholder', opts.delete(:class) ].compact * ' '
    image_tag 'friskyfactory/silhouette-q.gif', opts.merge(:site => false, :class => css_class)
  end
  
  def empty_image_tag(opts = {})
    css_class = [ 'empty', opts.delete(:class) ].compact * ' '
    image_tag 'friskyfactory/ffffff.gif', opts.merge(:site => false, :class => css_class)
  end
  
  def empty_thumb_image_tag(opts = {})
    css_class = [ 'thumb', opts.delete(:class) ].compact.join(' ')
    empty_image_tag(:class => css_class)
  end

end
