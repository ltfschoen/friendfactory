# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)

if [ "development", "test" ].include? ENV["RACK_ENV"]
  map "/system" do
    run Rack::File.new ENV["FRIENDFACTORY_ASSETS_ROOT"]
  end
end

run Friskyfactory::Application
