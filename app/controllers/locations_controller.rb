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
      geocode['results'].first
    else
      nil
    end 
    respond_to do |format|
      format.json { render :json => geocode }
    end
  end
  
end