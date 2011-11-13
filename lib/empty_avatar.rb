class EmptyAvatar

  EmptyAvatarUrl = '/images/silhouette-q.gif'

  attr_accessor :profile

  def initialize(profile)
    @profile = profile
  end

  def profile_id
    @profile.id
  end

  def user
    @profile.user
  end

  def url(style = nil)
    EmptyAvatarUrl
  end

  def silhouette?
    true
  end

end
