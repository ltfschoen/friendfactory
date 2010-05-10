require 'spec_helper'

describe Posting::TextsController do

  #Delete these examples and add some real ones
  it "should use Posting::TextsController" do
    controller.should be_an_instance_of(Posting::TextsController)
  end


  describe "GET 'create'" do
    it "should be successful" do
      get 'create'
      response.should be_success
    end
  end
end
