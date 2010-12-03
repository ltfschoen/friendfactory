require "spec_helper"

describe Wave::RollCallsController do
  describe 'routing' do
    it 'recognizes #index' do
      { :get => '/rollcall' }.should route_to(:controller => 'waves/roll_calls', :action => 'index')
    end

    it 'recognizes roll_call_path' do
      roll_call_path.should == '/rollcall'
    end

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
