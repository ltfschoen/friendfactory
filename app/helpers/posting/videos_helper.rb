module Posting::VideosHelper

  def link_to_youtube_video_image(posting, size = 'big')
    image_url = "http://img.youtube.com/vi/#{posting.vid}/" + (size == 'small' ? '2.jpg' : '0.jpg')
    video_image_tag = image_tag(image_url, :site => false, :class => 'youtube_thumb')
    video_play_image_tag = image_tag('video-play.png', :class => 'video-play', :size => '100x100')
    link_to(video_image_tag << video_play_image_tag, posting.url, :'data-vid' => posting.vid)
  end
  
end