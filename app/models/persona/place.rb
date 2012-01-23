require 'geolocation'

class Persona::Place < Persona::Base

  include Geolocation

  self.default_profile_type = 'Wave::Place'

  attr_accessible :location

  validates_presence_of :handle, :location

  def set_tag_list
    location_list = [ state, country ].compact.join(',')
    self.tag_list = location_list
    self.location_list = location_list
  end

end
