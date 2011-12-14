require "spec_helper"

describe ProfilesController do
  describe 'routing' do
    it 'recognizes #show' do
      pending
      { :get => '/profile' }.should route_to(:controller => 'waves/profile', :action => 'show')
    end

    it 'recognizes profile_path' do
      pending
      profile_path.should == '/profile'
    end

    it 'recognizes #edit' do
      pending
      { :get => '/profile/edit' }.should route_to(:controller => 'waves/profile', :action => 'edit')
    end

    it 'recognizes edit_profile_path' do
      pending
      edit_profile_path.should == '/profile/edit'
    end

    it 'recognizes #update' do
      pending
      { :put => '/profile' }.should route_to(:controller => 'waves/profile', :action => 'update')
    end
    
    it 'recognizes #avatar to update an avatar' do
      pending
      { :post => '/profile/avatar' }.should route_to(:controller => 'waves/profile', :action => 'avatar')
    end

    it 'recognizes avatar_profile_path' do
      pending
      avatar_profile_path.should == '/profile/avatar'
    end
  end    
end
