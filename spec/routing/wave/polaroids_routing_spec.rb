require "spec_helper"

describe Wave::PolaroidsController do
  describe "routing" do
    # it "recognizes and generates #index" do
    #   { :get => "/wave_polaroids" }.should route_to(:controller => "wave_polaroids", :action => "index")
    # end
    # 
    # it "recognizes and generates #new" do
    #   { :get => "/wave_polaroids/new" }.should route_to(:controller => "wave_polaroids", :action => "new")
    # end
    
    it "recognizes and generates #show" do
      { :get => '/wave/polaroids/1' }.should route_to(:controller => 'wave/polaroids', :action => 'show', :id => '1')
    end
    
    # it "recognizes and generates #edit" do
    #   { :get => "/wave_polaroids/1/edit" }.should route_to(:controller => "wave_polaroids", :action => "edit", :id => "1")
    # end
    # 
    # it "recognizes and generates #create" do
    #   { :post => "/wave_polaroids" }.should route_to(:controller => "wave_polaroids", :action => "create")
    # end
    # 
    # it "recognizes and generates #update" do
    #   { :put => "/wave_polaroids/1" }.should route_to(:controller => "wave_polaroids", :action => "update", :id => "1")
    # end
    # 
    # it "recognizes and generates #destroy" do
    #   { :delete => "/wave_polaroids/1" }.should route_to(:controller => "wave_polaroids", :action => "destroy", :id => "1")
    # end

  end
end
