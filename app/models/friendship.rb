class Friendship < ActiveRecord::Base
  belongs_to :user
  belongs_to :friend, :class_name => 'Wave::Profile'
  validates_presence_of :user
  validates_presence_of :friend
end
