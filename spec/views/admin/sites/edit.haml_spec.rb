require 'spec_helper'

describe "admin_sites/edit.html.haml" do
  before(:each) do
    @site = assign(:site, stub_model(Site))
  end

  it "renders the edit site form" do
    pending
    render
    rendered.should have_selector("form", :action => site_path(@site), :method => "post") do |form|
    end
  end
end
