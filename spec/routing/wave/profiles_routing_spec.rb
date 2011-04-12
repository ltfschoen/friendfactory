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

  #    it "recognizes and generates #create" do
  #      { :post => "/profiles" }.should route_to(:controller => "profiles", :action => "create")
  #    end
  #
  #    it "recognizes and generates #update" do
  #      { :put => "/profiles/1" }.should route_to(:controller => "profiles", :action => "update", :id => "1")
  #    end
  #
  #    it "recognizes and generates #destroy" do
  #      { :delete => "/profiles/1" }.should route_to(:controller => "profiles", :action => "destroy", :id => "1")
  #    end

end
