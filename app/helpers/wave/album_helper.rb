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

end