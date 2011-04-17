module Wave::AlbumHelper
  
  def new_wave_album
    @new_wave_album ||= begin
      Wave::Album.new.tap do |wave|
        wave.user = current_user
        wave.state = :unpublished
      end
    end
  end
  
  def supersized_album_photos(album)
    album.photos.inject([]) do |memo, photo|
      memo << { :image => photo.image.url(:original), :title => '' }
    end
  end
  
  def link_to_album_photo(album, photo, opts = {})
    link_to(render_photo(photo, :class => opts[:class]), wave_album_photo_path(album, photo), :target => '_blank')
  end

end