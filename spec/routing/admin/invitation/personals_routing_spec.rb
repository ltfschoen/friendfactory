require "spec_helper"

describe Admin::Invitation::PersonalsController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/admin/invitation/personals" }.should route_to(:controller => "admin/invitation/personals", :action => "index")
    end
  end
end
