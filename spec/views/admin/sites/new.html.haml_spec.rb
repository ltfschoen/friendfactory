require 'spec_helper'

describe "admin_sites/new.html.haml" do
  before(:each) do
    assign(:site, stub_model(Admin::Site).as_new_record)
  end

  it "renders new site form" do
    render

    rendered.should have_selector("form", :action => admin_sites_path, :method => "post") do |form|
    end
  end
end
