class Wave::Community < Wave::Base

  def publish_posting_to_waves(posting)
    publish_posting_to_profile_wave(posting)
  end

  def subject
    user.handle
  end

  def writable?(user_id)
    true
  end

end