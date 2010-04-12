require 'spec_helper'

describe "/waves/new.html.erb" do
  include WavesHelper

  before(:each) do
    assigns[:wave] = stub_model(Wave,
      :new_record? => true,
      :title => "value for title",
      :description => "value for description",
      :owner_id => 1
    )
  end

  it "renders new wave form" do
    render

    response.should have_tag("form[action=?][method=post]", waves_path) do
      with_tag("input#wave_title[name=?]", "wave[title]")
      with_tag("input#wave_description[name=?]", "wave[description]")
      with_tag("input#wave_owner_id[name=?]", "wave[owner_id]")
    end
  end
end
