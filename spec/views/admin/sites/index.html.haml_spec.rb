require 'spec_helper'

describe "admin_sites/index.html.haml" do
  before(:each) do
    assign(:admin_sites, [
      stub_model(Admin::Site),
      stub_model(Admin::Site)
    ])
  end

  it "renders a list of admin_sites" do
    render
  end
end
