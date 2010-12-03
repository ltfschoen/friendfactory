require "spec_helper"

describe Wave::RollCallsController do
  describe 'routing' do
    it 'recognizes #index' do
      { :get => '/rollcall' }.should route_to(:controller => 'waves/roll_calls', :action => 'index')
    end

    it 'recognizes rollcall_path' do
      rollcall_path.should == '/rollcall'
    end
  end
end
