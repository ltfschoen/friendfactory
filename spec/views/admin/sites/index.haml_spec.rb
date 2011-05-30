require 'spec_helper'

describe "admin_sites/index.html.haml" do
  before(:each) do
    assign(:admin_sites, [
      stub_model(Site),
      stub_model(Site)
    ])
  end

  it "renders a list of admin_sites" do
    pending
    render
  end
end
