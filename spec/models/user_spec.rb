# == Schema Information
# Schema version: 20100416032227
#
# Table name: users
#
#  id                 :integer(4)      not null, primary key
#  email              :string(255)     not null
#  handle             :string(255)
#  first_name         :string(255)
#  last_name          :string(255)
#  dob                :date
#  status             :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  crypted_password   :string(255)
#  password_salt      :string(255)
#  persistence_token  :string(255)
#  perishable_token   :string(255)
#  login_count        :integer(4)      default(0), not null
#  failed_login_count :integer(4)      default(0), not null
#  last_request_at    :datetime
#  current_login_at   :datetime
#  last_login_at      :datetime
#  current_login_ip   :string(255)
#  last_login_ip      :string(255)
#

require 'spec_helper'

describe User do
  before(:each) do
    @valid_attributes = {
      
    }
  end

  # it "should create a new instance given valid attributes" do
  #   User.create!(@valid_attributes)
  # end
end
