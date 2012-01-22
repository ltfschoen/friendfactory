class Persona::Ambassador < Persona::Person

  self.default_profile_type = 'Wave::Ambassador'

  attr_accessible :location, :description

  validates_presence_of :handle, :location

end
