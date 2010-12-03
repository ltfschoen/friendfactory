require 'spec_helper'

describe "wave_polaroids/edit.html.erb" do
  before(:each) do
    @polaroid = assign(:polaroid, stub_model(Wave::Polaroid,
      :new_record? => false
    ))
  end

  it "renders the edit polaroid form" do
    # render
    # rendered.should have_selector("form", :action => polaroid_path(@polaroid), :method => "post") do |form|
    # end
  end
end
