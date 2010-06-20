require 'spec_helper'

describe WavesController do
  describe "routing" do
    it "recognizes and generates #show with slug" do
      { :get => "/waves/hotties" }.should route_to(:controller => "waves", :action => "show", :slug => "hotties")
    end

    it "recognizes and generates #show with id" do
      { :get => "/waves/1" }.should route_to(:controller => "waves", :action => "show", :id => "1")
    end
    
    # it "recognizes and generates #edit" do
    #   pending do
    #     { :get => "/waves/1/edit" }.should route_to(:controller => "waves", :action => "edit", :id => "1")
    #   end
    # end

    # it "recognizes and generates #create" do
    #   pending do
    #     { :post => "/waves" }.should route_to(:controller => "waves", :action => "create") 
    #   end
    # end
    
    # it "recognizes and generates #update" do
    #   pending do
    #     { :put => "/waves/1" }.should route_to(:controller => "waves", :action => "update", :id => "1") 
    #   end
    # end
    
    # it "recognizes and generates #destroy" do
    #   pending do
    #     { :delete => "/waves/1" }.should route_to(:controller => "waves", :action => "destroy", :id => "1") 
    #   end
    # end
  end
end
