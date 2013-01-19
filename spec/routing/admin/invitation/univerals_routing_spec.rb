require "spec_helper"

module Admin
  module Invitation
    describe SitesController do
      describe "routing" do
        it "recognizes and generates #index" do
          pending
          { :get => "/admin/invitation/universals" }.should route_to(:controller => "admin/invitation/universals", :action => "index")
        end

        it "recognizes and generates #new" do
          pending
          { :get => "/admin/invitation/universals/new" }.should route_to(:controller => "admin/invitation/universals", :action => "new")
        end

        it "recognizes and generates #create" do
          pending
          { :post => "/admin/invitation/universals" }.should route_to(:controller => "admin/invitation/universals", :action => "create")
        end

        it "recognizes and generates #edit" do
          pending
          { :get => "/admin/invitation/universals/42/edit" }.should route_to(:controller => "admin/invitation/universals", :action => "edit", :id => "42")
        end

        it "recognizes and generates #create" do
          pending
          { :put => "/admin/invitation/universals/42" }.should route_to(:controller => "admin/invitation/universals", :action => "update", :id => "42")
        end

        it "recognizes and generates #destroy" do
          pending
          { :delete => "/admin/invitation/universals/42" }.should route_to(:controller => "admin/invitation/universals", :action => "destroy", :id => "42")
        end
      end
    end
  end
end
