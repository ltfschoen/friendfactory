require 'json'
require 'net/http'
require 'uri'

class LocationsController < ApplicationController

  GoogleMapsApi = 'maps.googleapis.com'
  
  def geocode
    http = Net::HTTP.new(GoogleMapsApi, 80)    
    escaped_params = URI.escape(params[:location][:address], Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
    resp = http.get("/maps/api/geocode/json?sensor=false&address=#{escaped_params}")
    geocode = JSON.parse(resp.body)
    geocode = if (geocode['status'] == 'OK') && (geocode['results'].length > 0)
      tmp = geocode['results'].first
      lat = tmp['geometry']['location']['lat']
      lng = tmp['geometry']['location']['lng']
      { 'formatted_address' => tmp['formatted_address'],
        'lat' => lat,
        'lng' => lng,
        'map_url' => "http://maps.google.com/maps/api/staticmap?zoom=15&size=210x210&markers=color:red|size:mid|#{lat},#{lng}&sensor=false",
        'link_url' => "http://maps.google.com/maps?ll=#{lat},#{lng}&q=#{escaped_params}" }
    else
      nil
    end 
    respond_to do |format|
      format.json { render :json => geocode }
    end
  end
  
end