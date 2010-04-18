require 'spec_helper'

describe "/postings/index.html.erb" do
  include PostingsHelper

  before(:each) do
    assigns[:postings] = [
      stub_model(Posting::Base),
      stub_model(Posting::Base)
    ]
  end

  # it "renders a list of postings" do
  #   render
  # end
end
