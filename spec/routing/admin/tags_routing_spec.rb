require "spec_helper"

describe Admin::TagsController do
  describe "routing" do

    it "recognizes and generates #index" do
      pending
      { :get => "/admin_tags" }.should route_to(:controller => "admin_tags", :action => "index")
    end

    it "recognizes and generates #new" do
      pending
      { :get => "/admin_tags/new" }.should route_to(:controller => "admin_tags", :action => "new")
    end

    it "recognizes and generates #show" do
      pending
      { :get => "/admin_tags/1" }.should route_to(:controller => "admin_tags", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      pending
      { :get => "/admin_tags/1/edit" }.should route_to(:controller => "admin_tags", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      pending
      { :post => "/admin_tags" }.should route_to(:controller => "admin_tags", :action => "create")
    end

    it "recognizes and generates #update" do
      pending
      { :put => "/admin_tags/1" }.should route_to(:controller => "admin_tags", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      pending
      { :delete => "/admin_tags/1" }.should route_to(:controller => "admin_tags", :action => "destroy", :id => "1")
    end

  end
end
