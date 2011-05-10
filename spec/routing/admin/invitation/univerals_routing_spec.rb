require "spec_helper"

describe Admin::Invitation::UniversalsController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/admin/invitation/universals" }.should route_to(:controller => "admin/invitation/universals", :action => "index")
    end
  end
end
