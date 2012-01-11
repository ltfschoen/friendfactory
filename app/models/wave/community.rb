class Wave::Community < Wave::Base

  alias_attribute :handle, :topic

  def publish_posting_to_waves(posting)
    publish_posting_to_profile_wave(posting)
  end

  def technical_description
    [ super, slug ].compact.join(' - ')
  end

  def subject
    'Community'
  end

end