require 'spec_helper'

describe "/walls/show.html.erb" do
  include WallsHelper
  before(:each) do
    assigns[:wall] = @wall = stub_model(Wall,
      :type => "value for type"
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/value\ for\ type/)
  end
end
