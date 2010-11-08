require 'spec_helper'

describe "wave_polaroids/show.html.erb" do
  before(:each) do
    @polaroid = assign(:polaroid, stub_model(Wave::Polaroid))
  end

  it "renders attributes in <p>" do
    # render
  end
end
