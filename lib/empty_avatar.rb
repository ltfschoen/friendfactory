class EmptyAvatar

  EmptyAvatarUrl = '/images/silhouette-q.gif'

  attr_accessor :profile

  def initialize(persona)
    @persona = persona
  end

  def profile_id
    @persona.id
  end

  def user
    @persona.user
  end

  def url(style = nil)
    EmptyAvatarUrl
  end

  def silhouette?
    true
  end

end
