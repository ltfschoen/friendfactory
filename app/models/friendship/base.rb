class Friendship::Base < ActiveRecord::Base

  set_table_name :friendships

  belongs_to :profile, :class_name => 'Wave::Base'

  belongs_to :friend, :class_name => 'Wave::Profile'

  validates_presence_of :profile_id, :friend_id

  alias_attribute :sender, :profile
  alias_attribute :receiver, :friend

  scope :type, lambda { |*types| where(:type => types.map(&:to_s)) }

end
