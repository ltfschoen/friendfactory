require 'spec_helper'

describe "Admin::Sites" do
  describe "GET /admin_sites" do
    it "works! (now write some real specs)" do
      visit admin_sites_path
      response.status.should be(200)
    end
  end
end
