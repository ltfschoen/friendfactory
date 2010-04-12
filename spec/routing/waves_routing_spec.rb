require 'spec_helper'

describe WavesController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/waves" }.should route_to(:controller => "waves", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/waves/new" }.should route_to(:controller => "waves", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/waves/1" }.should route_to(:controller => "waves", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/waves/1/edit" }.should route_to(:controller => "waves", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/waves" }.should route_to(:controller => "waves", :action => "create") 
    end

    it "recognizes and generates #update" do
      { :put => "/waves/1" }.should route_to(:controller => "waves", :action => "update", :id => "1") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "/waves/1" }.should route_to(:controller => "waves", :action => "destroy", :id => "1") 
    end
  end
end
