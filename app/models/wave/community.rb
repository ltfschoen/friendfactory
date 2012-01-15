class Wave::Community < Wave::Base

  def publish_posting_to_waves(posting)
    publish_posting_to_profile_wave(posting)
  end

  def subject
    (slug && slug.titleize) || 'Community'
  end

end