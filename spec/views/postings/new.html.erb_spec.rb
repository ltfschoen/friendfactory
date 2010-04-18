require 'spec_helper'

describe "/postings/new.html.erb" do
  include PostingsHelper

  before(:each) do
    assigns[:posting] = stub_model(Posting::Base,
      :new_record? => true
    )
  end

  # it "renders new posting form" do
  #   render
  #   response.should have_tag("form[action=?][method=post]", postings_path) do
  #   end
  # end
end
