require 'spec_helper'

describe HottiesController do

  it "should use HottiesController" do
    controller.should be_an_instance_of(HottiesController)
  end

  describe "GET 'show'" do
    it "should be successful" do
      get 'show'
      response.should be_success
    end

    it "should assign the correct wave" do
      assigns[:wave].title.should == 'Hotties'
    end
  end
end
