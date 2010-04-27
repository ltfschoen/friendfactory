class Friendship < ActiveRecord::Base
  belongs_to :user
  belongs_to :buddy, :class_name  => 'User'
end
