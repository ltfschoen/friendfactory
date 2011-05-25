require 'spec_helper'

describe "admin_sites/show.html.haml" do
  before(:each) do
    @site = assign(:site, stub_model(Admin::Site))
  end

  it "renders attributes in <p>" do
    render
  end
end
