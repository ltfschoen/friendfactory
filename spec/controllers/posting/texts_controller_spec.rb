require 'spec_helper'

describe Posting::TextsController do

  #Delete these examples and add some real ones
  it "should use Posting::TextsController" do
    pending
    controller.should be_an_instance_of(Postings::TextsController)
  end


  describe "GET 'create'" do
    it "should be successful" do
      pending
      get 'create'
      response.should be_success
    end
  end
end
