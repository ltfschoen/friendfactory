class Persona::Condition < Persona::Base

  self.default_profile_type = 'Wave::Community'

  attr_accessible :description

  validates_presence_of :handle, :description

end
