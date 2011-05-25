require "spec_helper"

describe Admin::SitesController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/admin_sites" }.should route_to(:controller => "admin_sites", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/admin_sites/new" }.should route_to(:controller => "admin_sites", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/admin_sites/1" }.should route_to(:controller => "admin_sites", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/admin_sites/1/edit" }.should route_to(:controller => "admin_sites", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/admin_sites" }.should route_to(:controller => "admin_sites", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/admin_sites/1" }.should route_to(:controller => "admin_sites", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/admin_sites/1" }.should route_to(:controller => "admin_sites", :action => "destroy", :id => "1")
    end

  end
end
