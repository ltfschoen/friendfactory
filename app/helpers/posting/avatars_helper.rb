module Posting::AvatarsHelper

  def link_to_profile(personage, opts = {})
    if personage.present?
      name = opts[:label] || personage.display_handle
      link_to(name, url_for(personage.profile), :class => 'profile username')
    end
  end

  def thimble_link_to_profile(personage, *args)
    opts = args.extract_options!
    path = args.first || url_for(personage.profile)
    render :partial => 'posting/avatars/thimble_link_to_profile', :locals => { :personage => personage, :path => path, :opts => opts }
  end

  def monochrome_thimble_image_tag(personage, opts = {})
    thimble_image_tag(personage, opts.merge(:style => 'thimblebw'))
  end

  def thimble_image_tag(personage, opts = {})
    if personage && personage.avatar
      handle = personage.handle
      size = opts.delete(:size) || '32x32'
      style = opts.delete(:style) || 'thimble'
      css_class = [ opts.delete(:class), 'thimble', "pid-#{personage[:id]}" ].compact.join(' ')
      image_tag(personage.avatar.url(style.to_sym), :size => size, :alt => handle, :title => handle, :class => css_class)
    elsif personage
      Rails.logger.warn "Personage:#{personage.id} has no avatar"
      content_tag(:span, "&nbsp;".html_safe, :class => 'avatar-with-error', :style => 'display:inline-block;width:32px;height:32px;')
    end
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
