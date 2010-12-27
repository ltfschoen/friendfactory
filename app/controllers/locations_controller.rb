require 'json'
require 'net/http'
require 'uri'

class LocationsController < ApplicationController

  GoogleMapsApi = 'maps.googleapis.com'
  
  def geocode
    escaped_params = URI.escape(params[:location][:address], Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
    http = Net::HTTP.new(GoogleMapsApi, 80)    
    response = http.get("/maps/api/geocode/json?sensor=false&address=#{escaped_params}")
    geocode = JSON.parse(response.body)
    
    respond_to do |format|
      if (geocode['status'] == 'OK')
        location = get_location_from_geocode(geocode['results'])
        location.merge!(google_map_urls(location['lat'], location['lng'], escaped_params)) unless location.empty?
        format.json { render :json => location }
      else
        format.json { render :json => {} }
      end      
    end
  end
  
  private
  
  def get_location_from_geocode(geocode)    
    if geocode.try(:length) > 0
      location = geocode.first
      city  = get_address_component(location['address_components'], 'locality')
      state = get_address_component(location['address_components'], 'administrative_area_level_1')
      lat   = location['geometry']['location']['lat']
      lng   = location['geometry']['location']['lng']
      
      { 'address' => location['formatted_address'],
        'city'    => city,
        'state'   => state,
        'lat'     => lat,
        'lng'     => lng }
    else
      {}
    end
  end
    
  def get_address_component(address_components, component_type)
    address_components.each do |address_component|
      if address_component['types'].include?(component_type)
        return address_component['short_name']
      end
    end
  end

  def google_map_urls(lat, lng, escaped_params)
    { 'map_url'  => "http://maps.google.com/maps/api/staticmap?zoom=15&size=210x210&markers=color:red|size:mid|#{lat},#{lng}&sensor=false",
      'link_url' => "http://maps.google.com/maps?ll=#{lat},#{lng}&q=#{escaped_params}" }    
  end
  
end