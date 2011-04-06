module Posting::AvatarsHelper
  
  def placeholder_image_tag(opts = {})
    image_tag 'friskyfactory/silhouette-q.gif', :site => false, :class => opts[:class]
  end
  
  def empty_image_tag(opts = {})
    image_tag 'friskyfactory/ffffff.gif', :site => false, :class => opts[:class]
  end
  
end
