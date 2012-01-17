require 'wave_avatar'

class Persona::Community < Persona::Base

  extend ActiveSupport::Memoizable

  self.default_profile_type = 'Wave::Community'

  attr_accessible :description

  validates_presence_of :handle, :description

  def avatar
    super || WaveAvatar.new(user)
  end

  memoize :avatar

end
