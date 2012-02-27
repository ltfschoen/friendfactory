require 'geolocation'

class Persona::Ambassador < Persona::Base

  include Geolocation

  self.default_profile_type = 'Wave::Ambassador'

  attr_accessible :location, :description

  validates_presence_of :handle

  def first_name
    self[:first_name].present? ? self[:first_name].strip.titleize : handle
  end

  def last_name
    self[:last_name].strip.titleize if self[:last_name].present?
  end

  def full_name
    [ first_name, last_name ].compact.join(' ')
  end

end
