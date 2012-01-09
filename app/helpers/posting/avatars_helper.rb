module Posting::AvatarsHelper

  def link_to_profile(personage, opts = {})
    if personage.present?
      name = opts[:label] || personage.handle
      link_to(name, url_for(personage.profile), :class => 'profile username')
    end
  end

  def thimble_link_to_profile(personage, path = nil)
    render :partial => 'posting/avatars/thimble_link_to_profile', :locals => { :personage => personage, :path => path }
  end

  def thimble_image_tag(personage, opts = {})
    if personage.present?
      handle = personage.handle
      size = opts.delete(:size) || '32x32'
      image_tag(personage.avatar.url(:thumb), :size => size, :alt => handle, :title => handle)
    end
  end

  def headshot_image_tag(profile, opts = {})
    opts.merge!(:size => '190x190', :alt => profile.handle, :title => profile.handle)
    image_tag(profile.avatar.url(:polaroid), opts)
  end

  def placeholder_image_tag(opts = {})
    css_class = [ 'placeholder', opts.delete(:class) ].compact * ' '
    image_tag 'friskyfactory/silhouette-q.gif', opts.merge(:site => false, :class => css_class)
  end

  def empty_image_tag(opts = {})
    css_class = [ 'empty', opts.delete(:class) ].compact * ' '
    image_tag 'ffffff.gif', opts.merge(:site => false, :class => css_class)
  end

  def empty_thumb_image_tag(opts = {})
    css_class = [ 'thumb', opts.delete(:class) ].compact.join(' ')
    empty_image_tag(:class => css_class)
  end

end
