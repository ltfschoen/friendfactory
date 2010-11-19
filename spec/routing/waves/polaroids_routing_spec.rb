require "spec_helper"

describe Waves::PolaroidsController do
  describe 'routing' do
    it 'recognizes #index' do
      pending
      { :get => '/waves/polaroids' }.should route_to(:controller => 'waves/polaroids', :action => 'index')
    end

    it 'recognizes waves_polaroids_path' do
      pending
      waves_polaroids_path.should == '/waves/polaroids'
    end
  end
end
