require "spec_helper"

describe Waves::ProfileController do
  describe 'routing' do
    it 'recognizes #show' do
      { :get => '/profile' }.should route_to(:controller => 'waves/profile', :action => 'show')
    end

    it 'recognizes profile_path' do
      profile_path.should == '/profile'
    end

    it 'recognizes #update' do
      { :put => '/profile' }.should route_to(:controller => 'waves/profile', :action => 'update')
    end
  end    
end
