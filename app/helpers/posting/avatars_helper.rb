module Posting::AvatarsHelper
  
  def placeholder_image_tag(opts = {})
    image_tag 'friskyfactory/silhouette-q.gif', :site => false, :class => opts[:class]
  end
  
  def empty_image_tag(opts = {})
    css_class = [ 'empty', opts.delete(:class) ].compact * ' '
    image_tag 'friskyfactory/ffffff.gif', :site => false, :class => css_class
  end
  
end
