require 'spec_helper'

describe "/profiles/index.html.erb" do
  # include ProfilesHelper

  before(:each) do
    assigns[:profiles] = [
      mock_model(Wave::Profile),
      mock_model(Wave::Profile)
    ]
  end

  it "renders a list of profiles" do
    pending
    render
  end
end
