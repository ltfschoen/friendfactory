require 'json'
require 'net/http'
require 'uri'

module Geolocation

  GoogleMapsApi = 'maps.googleapis.com'

  attr_accessor :geocode

  def location=(location)
    write_attribute(:location, location)
    if location.present? && geocode = geocoded_location
      geocode.map { |k, v|  write_attribute(k ,v) }
    else
      nullify_location_attributes
    end
  end

  def city
    self[:city]
  end

  def city_with_locality
    city_without_locality || self[:locality]
  end

  alias_method_chain :city, :locality

  def map_url(opts = {})
    size = opts.delete(:size) || '180x180'
    "http://maps.google.com/maps/api/staticmap?zoom=8&size=#{size}&markers=color:red|size:mid|#{lat},#{lng}&sensor=false"
  end

  def link_url
    "http://maps.google.com/maps?ll=#{lat},#{lng}&q=#{escaped_location}"
  end

  private

  def escaped_location
    if location
      URI.escape(self[:location], Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
    end
  end

  def geocoded_location
    http = Net::HTTP.new(GoogleMapsApi, 80)
    response = http.get("/maps/api/geocode/json?sensor=false&address=#{escaped_location}")
    geocode = JSON.parse(response.body)
    if geocode && (geocode['status'] == 'OK')
      @geocode = geocode['results'].first
      get_address_from_geocode(geocode['results'])
    end
  rescue
    nil
  end

  def get_address_from_geocode(geocode)
    if geocode && geocode.length > 0
      location      = geocode.first
      address       = location['formatted_address']
      subpremise    = get_address_component(location['address_components'], 'subpremise')
      street_number = get_address_component(location['address_components'], 'street_number')
      street        = get_address_component(location['address_components'], 'route')
      neighborhood  = get_address_component(location['address_components'], 'neighborhood')
      sublocality   = get_address_component(location['address_components'], 'sublocality')
      locality      = get_address_component(location['address_components'], 'locality')
      city          = get_address_component(location['address_components'], 'administrative_area_level_2')
      abbreviated_state = get_address_component(location['address_components'], 'administrative_area_level_1')
      state         = get_address_component(location['address_components'], 'administrative_area_level_1', 'long_name')
      country       = get_address_component(location['address_components'], 'country', 'long_name')
      post_code     = get_address_component(location['address_components'], 'postal_code')
      lat           = location['geometry']['location']['lat']
      lng           = location['geometry']['location']['lng']

      Hash[
          :address,           address,
          :subpremise,        subpremise,
          :street_number,     street_number,
          :street,            street,
          :neighborhood,      neighborhood,
          :locality,          locality,
          :city,              city,
          :abbreviated_state, abbreviated_state,
          :state,             state,
          :country,           country,
          :post_code,         post_code,
          :lat,               lat,
          :lng,               lng ]
    end
  end

  def get_address_component(address_components, component_type, format = 'short_name')
    address_components.each do |address_component|
      if address_component['types'].include?(component_type)
        return address_component[format]
      end
    end
    nil
  end

  def nullify_location_attributes
    [ :address,
      :subpremise,
      :street_number,
      :street,
      :neighborhood,
      :sublocality,
      :locality,
      :city,
      :abbreviated_state,
      :state,
      :country,
      :post_code,
      :lat,
      :lng ].each { |attr| write_attribute(attr, nil) }
  end

end
