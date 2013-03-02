require 'subscribable'

class Friendship::Base < ActiveRecord::Base

  include Subscribable

  self.table_name = "friendships"

  attr_accessible :friend

  validates_presence_of :user

  belongs_to :user, :class_name => 'Personage'

  belongs_to :friend, :class_name => 'Personage'

  scope :type, lambda { |*types|
    where(:type => types.map(&:to_s))
  }

  scope :since, lambda { |datetime|
    where('"created_at" > ?', datetime)
  }

end
