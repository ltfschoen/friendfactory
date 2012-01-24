class Friendship::Base < ActiveRecord::Base

  set_table_name :friendships

  belongs_to :user, :class_name => 'Personage'
  alias_attribute :sender, :user

  belongs_to :friend, :class_name => 'Personage'
  alias_attribute :receiver, :friend

  validates_presence_of :user_id, :friend_id

  scope :type, lambda { |*types| where(:type => types.map(&:to_s)) }

end
