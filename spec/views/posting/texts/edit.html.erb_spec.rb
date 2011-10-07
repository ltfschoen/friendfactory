require 'spec_helper'

describe "/postings/edit.html.erb" do
  include Posting::PostingsHelper

  before(:each) do
    assigns[:posting] = @posting = stub_model(Posting::Base,
      :new_record? => false
    )
  end

  # it "renders the edit posting form" do
  #   render
  #   response.should have_tag("form[action=#{posting_path(@posting)}][method=post]") do
  #   end
  # end
end
