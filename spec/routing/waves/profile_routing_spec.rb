require "spec_helper"

describe Waves::ProfileController do
  describe 'routing' do
    it 'recognizes #show' do
      { :get => '/profile' }.should route_to(:controller => 'waves/profile', :action => 'show')
    end

    it 'recognizes profile_path' do
      profile_path.should == '/profile'
    end

    it 'recognizes #edit' do
      { :get => '/profile/edit' }.should route_to(:controller => 'waves/profile', :action => 'edit')
    end

    it 'recognizes edit_profile_path' do
      edit_profile_path.should == '/profile/edit'
    end

    it 'recognizes #update' do
      { :put => '/profile' }.should route_to(:controller => 'waves/profile', :action => 'update')
    end
    
    it 'recognizes #avatar' do
      { :post => '/profile/avatar' }.should route_to(:controller => 'waves/profile', :action => 'avatar')
    end

    it 'recognizes avatar_profile_path' do
      avatar_profile_path.should == '/profile/avatar'
    end
  end    
end
