class Wave::Community < Wave::Base

  alias_attribute :handle, :topic

  class WaveIconAvatar
    def url(style = nil)
      'wave-icon.png'
    end
  end

  def publish_posting_to_waves(posting)
    publish_posting_to_profile_wave(posting)
  end

  def technical_description
    [ super, slug ].compact * ' - '
  end

  def avatar
    @avatar ||= WaveIconAvatar.new
  end

end