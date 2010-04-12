require 'spec_helper'

describe Wave do
  before(:each) do
    @valid_attributes = {
      :title => "value for title",
      :description => "value for description",
      :owner_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    Wave.create!(@valid_attributes)
  end
end
