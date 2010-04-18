# == Schema Information
# Schema version: 20100416032227
#
# Table name: postings
#
#  id                  :integer(4)      not null, primary key
#  type                :string(255)
#  parent_id           :integer(4)
#  author_id           :integer(4)
#  created_at          :datetime
#  updated_at          :datetime
#  receiver_id         :integer(4)      not null
#  subject             :text
#  body                :text
#  read_at             :datetime
#  sender_deleted_at   :datetime
#  receiver_deleted_at :datetime
#

require 'spec_helper'

describe Posting::Comment do
  before(:each) do
    @valid_attributes = {
      
    }
  end

  # it "should create a new instance given valid attributes" do
  #   Comment.create!(@valid_attributes)
  # end
end
