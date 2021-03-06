require 'digest/sha1'

module Wave::WavesHelper

  def posting_sidebar(posting)
    case posting.class.name
      when 'Posting::Message' then 'Private'
      else 'Public'
    end
  end

  # Chat Controller
  def chat_channel(sender, receiver)
    Digest::SHA1.hexdigest([ sender, receiver ].sort.to_s)[0..7]
  end
  
  # Hotties Controller
  # def flag_hottie
  #   content_tag_for :div, avatar do
  #     returning String.new do |html|
  #       html << image_tag(avatar.image.url(:thumb), :class => klass, :site => false) unless avatar.nil?
  #       html << image_tag('/images/icons/star.png', :class => 'flag_hottie', :site => false, :alt => 'Flag as hottie')
  #     end
  #   end    
  # end
  
  # Communities Controller
  
  def new_posting_photo
    @new_posting_photo ||= new_posting(Posting::Photo)
  end

  def new_posting_video
    @new_posting_video ||= new_posting(Posting::Video)
  end
  
  def new_posting(klass)
    posting = klass.new
    posting.user = current_user
    posting
  end
    
end
