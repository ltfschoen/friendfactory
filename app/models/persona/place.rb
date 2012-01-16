require 'json'
require 'net/http'
require 'uri'

class Persona::Place < Persona::Base

  GoogleMapsApi = 'maps.googleapis.com'

  self.default_profile_type = 'Wave::Place'

  attr_accessible :location

  validates_presence_of :handle, :location

  def location=(location)
    write_attribute(:location, location)
    if geocode = geocoded_location
      write_attribute(:address, geocode[:address])
      write_attribute(:city, geocode[:city])
      write_attribute(:state, geocode[:state])
      write_attribute(:lat, geocode[:lat])
      write_attribute(:lng, geocode[:lng])
    end
  end

  def map_url
    "http://maps.google.com/maps/api/staticmap?zoom=15&size=180x156&markers=color:red|size:mid|#{lat},#{lng}&sensor=false"
  end

  def link_url
    "http://maps.google.com/maps?ll=#{lat},#{lng}&q=#{escaped_location}"
  end

  private

  def escaped_location
    if location
      URI.escape(location, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
    end
  end

  def geocoded_location
    http = Net::HTTP.new(GoogleMapsApi, 80)
    response = http.get("/maps/api/geocode/json?sensor=false&address=#{escaped_location}")
    geocode = JSON.parse(response.body)
    if geocode && (geocode['status'] == 'OK')
      get_address_from_geocode(geocode['results'])
    end
  rescue
    nil
  end

  def get_address_from_geocode(geocode)
    if geocode && geocode.length > 0
      location = geocode.first
      address  = location['formatted_address']
      city     = get_address_component(location['address_components'], 'locality')
      state    = get_address_component(location['address_components'], 'administrative_area_level_1')
      lat      = location['geometry']['location']['lat']
      lng      = location['geometry']['location']['lng']

      Hash[ :address, address, :city, city, :state, state, :lat, lat, :lng, lng ]
    end
  end

  def get_address_component(address_components, component_type)
    address_components.each do |address_component|
      if address_component['types'].include?(component_type)
        return address_component['short_name']
      end
    end
  end

end
