module Posting::VideosHelper

  def link_to_youtube_video_image(url, size = 'big')
    results = /[\\?&]v=([^&#]*)/.match(url)
    vid = (results.nil?) ? url : results[1]
    image_url = "http://img.youtube.com/vi/#{vid}/" + ((size == 'small') ? '2.jpg' : '0.jpg')
    link_to(image_tag(image_url, :site => false, :class => 'youtube_thumb'), url)
  end
  
end