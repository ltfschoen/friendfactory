class EmptyAvatar

  EmptyAvatarUrl = '/assets/silhouette-q.gif'

  def initialize(persona)
    @persona = persona
  end

  def user
    @persona.user
  end

  def profile
    @persona.user.profile
  end

  def url(style = nil)
    EmptyAvatarUrl
  end

  def silhouette?
    true
  end

end
