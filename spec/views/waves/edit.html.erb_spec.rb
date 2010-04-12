require 'spec_helper'

describe "/waves/edit.html.erb" do
  include WavesHelper

  before(:each) do
    assigns[:wave] = @wave = stub_model(Wave,
      :new_record? => false,
      :title => "value for title",
      :description => "value for description",
      :owner_id => 1
    )
  end

  it "renders the edit wave form" do
    render

    response.should have_tag("form[action=#{wave_path(@wave)}][method=post]") do
      with_tag('input#wave_title[name=?]', "wave[title]")
      with_tag('input#wave_description[name=?]', "wave[description]")
      with_tag('input#wave_owner_id[name=?]', "wave[owner_id]")
    end
  end
end
