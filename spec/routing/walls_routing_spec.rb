require 'spec_helper'

describe Wall::WallsController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/walls" }.should route_to(:controller => "walls", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/walls/new" }.should route_to(:controller => "walls", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/walls/1" }.should route_to(:controller => "walls", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/walls/1/edit" }.should route_to(:controller => "walls", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/walls" }.should route_to(:controller => "walls", :action => "create") 
    end

    it "recognizes and generates #update" do
      { :put => "/walls/1" }.should route_to(:controller => "walls", :action => "update", :id => "1") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "/walls/1" }.should route_to(:controller => "walls", :action => "destroy", :id => "1") 
    end
  end
end
