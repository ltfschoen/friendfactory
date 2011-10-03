module Posting::AvatarsHelper

  def thimble_link_to_profile(user, opts = {})
    profile = user.profile(current_site)
    link_to(image_tag(profile.avatar.image.url(:thumb), :size => '32x32'), wave_profile_path(profile))
  end
  
  def thumb_avatar_image_tag(avatar, opts = {})
    image_tag avatar.url(:thumb), wave_profile_path(avatar.profile(current_site)), :size => '100x100'
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
