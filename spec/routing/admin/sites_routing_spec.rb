require "spec_helper"

describe Admin::SitesController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/admin/sites" }.should route_to(:controller => "admin/sites", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/admin/sites/new" }.should route_to(:controller => "admin/sites", :action => "new")
    end

    it "recognizes and generates #create" do
      { :post => "/admin/sites" }.should route_to(:controller => "admin/sites", :action => "create")
    end

    it "recognizes and generates #edit" do
      { :get => "/admin/sites/1/edit" }.should route_to(:controller => "admin/sites", :action => "edit", :id => "1")
    end

    it "recognizes and generates #update" do
      { :put => "/admin/sites/1" }.should route_to(:controller => "admin/sites", :action => "update", :id => "1")
    end

    it "recognizes and generates #stylesheets" do
      pending
      { :get => "/stylesheets/welcome.css" }.should route_to(:controller => "admin/sites", :action => "stylesheets", :layout => "welcome", :format => "css")
    end
  end
end
