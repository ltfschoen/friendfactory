require 'spec_helper'

describe "/profiles/show.html.erb" do
  # include ProfilesHelper
  
  before(:each) do
    assigns[:profile] = @profile = stub_model(Wave::Profile)
  end

  it "renders attributes in <p>" do
    pending
    render
  end
end
