require 'spec_helper'

describe "/waves/show.html.erb" do
  include WavesHelper
  before(:each) do
    assigns[:wave] = @wave = stub_model(Wave::Base,
      :title => "value for title",
      :description => "value for description",
      :owner_id => 1
    )
  end

  # it "renders attributes in <p>" do
  #   pending do
  #     render
  #     response.should have_text(/value\ for\ title/)
  #     response.should have_text(/value\ for\ description/)
  #     response.should have_text(/1/)
  #   end
  # end
end
