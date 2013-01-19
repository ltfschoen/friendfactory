require "spec_helper"

module Admin
  module Invitation
    describe PersonalsController do
      describe "routing" do
        it "recognizes and generates #index" do
          pending
          { :get => "/admin/invitation/personals" }.should route_to(:controller => "admin/invitation/personals", :action => "index")
        end
      end
    end
  end
end
