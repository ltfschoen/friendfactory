class Friendship::Base < ActiveRecord::Base

  set_table_name :friendships

  attr_accessible :friend

  validates_presence_of :user

  belongs_to :user, :class_name => 'Personage'

  belongs_to :friend, :class_name => 'Personage'

  scope :type, lambda { |*types| where(:type => types.map(&:to_s)) }

end
