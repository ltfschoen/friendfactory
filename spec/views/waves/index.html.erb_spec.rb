require 'spec_helper'

describe "/waves/index.html.erb" do
  include WavesHelper

  before(:each) do
    assigns[:waves] = [
      stub_model(Wave,
        :title => "value for title",
        :description => "value for description",
        :owner_id => 1
      ),
      stub_model(Wave,
        :title => "value for title",
        :description => "value for description",
        :owner_id => 1
      )
    ]
  end

  it "renders a list of waves" do
    render
    response.should have_tag("tr>td", "value for title".to_s, 2)
    response.should have_tag("tr>td", "value for description".to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
  end
end
