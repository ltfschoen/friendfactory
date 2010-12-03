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

describe Wave::Base do
  before(:each) do
    @valid_attributes = {
      :title => "value for title",
      :description => "value for description",
      :owner_id => 1
    }
  end

  # it "should create a new instance given valid attributes" do
  #   Wave.create!(@valid_attributes)
  # end
end
