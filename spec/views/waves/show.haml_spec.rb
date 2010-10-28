require 'spec_helper'

describe "/waves/show.haml" do
  
  include Authlogic::TestCase
  include WavesHelper
  
  before(:each) do
    activate_authlogic    
  end

  it "should have a menu bar to root wave" do
    pending
    Posting.stub_chain(:postings, :for).and_return([mock(Posting)])
    assigns[:wave] = stub_model(Wave::Base, :postings => stub)
    render
    response.should have_tag('a[href="/"]')
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
