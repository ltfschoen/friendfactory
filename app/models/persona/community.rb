require 'wave_avatar'

class Persona::Community < Persona::Base

  extend ActiveSupport::Memoizable

  self.default_profile_type = 'Wave::Community'

  def avatar
    super || WaveAvatar.new(user)
  end

  memoize :avatar

end
