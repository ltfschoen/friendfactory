require 'spec_helper'

describe Wave::HottiesController do

  it "should use Waves::HottiesController" do
    pending
    controller.should be_an_instance_of(Waves::HottiesController)
  end

  describe "GET 'show'" do
    it "should be successful" do
      pending
      get 'show'
      response.should be_success
    end

    it "should assign the correct wave" do
      pending
      assigns[:wave].title.should == 'Hotties'
    end
  end
end
