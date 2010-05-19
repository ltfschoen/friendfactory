module HottiesHelper

  def flag_hottie
    content_tag_for :div, avatar do
      returning String.new do |html|
        html << image_tag(avatar.image.url(:thumb), :class => klass, :site => false) unless avatar.nil?
        html << image_tag('/images/icons/star.png', :class => 'flag_hottie', :site => false, :alt => 'Flag as hottie')
      end
    end    
  end
  
end
