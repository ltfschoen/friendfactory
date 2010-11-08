require "spec_helper"

describe Waves::PolaroidsController do
  describe 'routing' do
    it 'recognizes #index' do
      { :get => '/waves/polaroids' }.should route_to(:controller => 'waves/polaroids', :action => 'index')
    end

    it 'recognizes waves_polaroids_path' do
      waves_polaroids_path.should == '/waves/polaroids'
    end

    it 'recognizes get #show' do
      { :get => '/waves/polaroids/37' }.should route_to(:controller => 'waves/polaroids', :action => 'show', :id => '37')
    end

    it 'recognizes waves_polaroid_path' do
      waves_polaroid_path('37').should == '/waves/polaroids/37'
    end
  end
end
