require "spec_helper"

describe Admin::Invitation::UniversalsController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/admin/invitation/universals" }.should route_to(:controller => "admin/invitation/universals", :action => "index")
    end
    
    it "recognizes and generates #new" do
      { :get => "/admin/invitation/universals/new" }.should route_to(:controller => "admin/invitation/universals", :action => "new")
    end
    
    it "recognizes and generates #create" do
      { :post => "/admin/invitation/universals" }.should route_to(:controller => "admin/invitation/universals", :action => "create")
    end

    it "recognizes and generates #edit" do
      { :get => "/admin/invitation/universals/42/edit" }.should route_to(:controller => "admin/invitation/universals", :action => "edit", :id => "42")
    end

    it "recognizes and generates #create" do
      { :put => "/admin/invitation/universals/42" }.should route_to(:controller => "admin/invitation/universals", :action => "update", :id => "42")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/admin/invitation/universals/42" }.should route_to(:controller => "admin/invitation/universals", :action => "destroy", :id => "42")
    end
  end
end
