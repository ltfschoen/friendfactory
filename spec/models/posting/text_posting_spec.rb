require 'spec_helper'

describe Posting::Text do
  before(:each) do
    @valid_attributes = { :parent_id => 1 }
  end

  it "is valid with valid attributes" do
    pending
    Posting::Text.new(:body => 'foo').should be_valid
  end
  
  it "is not valid without a body" do
    pending
    Posting::Text.new(:body => nil).should_not be_valid
  end

end
