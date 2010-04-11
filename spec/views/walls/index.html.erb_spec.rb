require 'spec_helper'

describe "/walls/index.html.erb" do
  include WallsHelper

  before(:each) do
    assigns[:walls] = [
      stub_model(Wall,
        :type => "value for type"
      ),
      stub_model(Wall,
        :type => "value for type"
      )
    ]
  end

  it "renders a list of walls" do
    render
    response.should have_tag("tr>td", "value for type".to_s, 2)
  end
end
