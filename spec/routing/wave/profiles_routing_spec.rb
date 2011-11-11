require "spec_helper"

describe Wave::ProfilesController do
  describe 'routing' do
    it 'recognizes #show' do
      pending
      { :get => '/waves/profiles/42' }.should route_to(:controller => 'waves/profiles', :action => 'show', :id => '42')
    end

    it 'recognizes waves_profile_path(42)' do
      pending
      waves_profile_path(42).should == '/waves/profiles/42'
    end
    
    it 'recognizes photos' do
      pending
      { :get => '/waves/profiles/42/photos' }.should route_to(:controller => 'waves/profiles', :action => 'photos', :id => '42')
    end

    it 'recognizes photos_waves_profile_path(42)' do
      pending
      photos_waves_profile_path(42).should == '/waves/profiles/42/photos'
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
