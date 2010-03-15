module UsersHelper
  
  def user_image_tag(image, opts = {})
    image_tag('portrait_default.gif', opts.merge(:factory_image => true))
  end
  
end
