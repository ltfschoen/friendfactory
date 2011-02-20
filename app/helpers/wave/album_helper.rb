module Wave::AlbumHelper
  
  def new_wave_album
    @new_wave_album ||= begin
      Wave::Album.new.tap do |wave|
        wave.user = current_user
        wave.state = :unpublished
      end
    end
  end

end