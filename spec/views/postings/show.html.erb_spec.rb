require 'spec_helper'

describe "/postings/show.html.erb" do
  include PostingsHelper
  before(:each) do
    assigns[:posting] = @posting = stub_model(Posting::Base)
  end

  # it "renders attributes in <p>" do
  #   render
  # end
end
