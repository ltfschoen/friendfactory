class EmptyAvatar

  EmptyAvatarUrl = '/images/silhouette-q.gif'

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
    EmptyAvatarUrl
  end

  def silhouette?
    true
  end

end
