class WaveAvatar

  WaveAvatarUrl = 'wave-icon.png'

  def initialize(personage)
    @personage = personage
  end

  def user
    @personage
  end

  def profile
    @personage.profile
  end

  def url(style = nil)
    WaveAvatarUrl
  end

  def silhouette?
    false
  end

end
