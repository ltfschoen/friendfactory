module Posting::VideosHelper

  def link_to_youtube_video_image(posting, size = 'big')
    image_url = "http://img.youtube.com/vi/#{posting.vid}/" + (size == 'small' ? '2.jpg' : '0.jpg')
    link_to(image_tag(image_url, :site => false, :class => 'youtube_thumb'), posting.url, :'data-vid' => posting.vid)
  end
  
end