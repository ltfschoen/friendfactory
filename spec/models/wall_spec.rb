require 'spec_helper'

describe Wall do
  before(:each) do
    @valid_attributes = {
      :type => "value for type"
    }
  end

  it "should create a new instance given valid attributes" do
    Wall.create!(@valid_attributes)
  end
end
