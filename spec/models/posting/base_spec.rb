require 'spec_helper'

describe Posting::Base do

  describe "read only" do
    # fixtures :users
    it 'user' do
      pending
      adam = users(:adam)
      video.user = adam
      video.save!
      video.user = users(:bert)
      video.save!
      video.reload
      video.user.should == adam
    end
  end

end