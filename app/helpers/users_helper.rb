module UsersHelper
  
  def avatar_image_tag(source, opts = {})
    klass = [ opts.delete(:class), 'avatar' ].compact * ' '
    image_tag(source, opts.merge(:class => klass))
  end
  
end
