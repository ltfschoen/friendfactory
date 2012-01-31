class Invitation::Base < ActiveRecord::Base

  include ActiveRecord::Transitions

  set_table_name 'invitations'

  state_machine do
    state :offered
    state :accepted
    state :expired

    event :accept do
      transitions :to => :accepted, :from => [ :offered ], :guard => lambda { |invitation| invitation.acceptable? }
    end

    event :expire do
      transitions :to => :expired, :from => [ :offered ]
    end
  end

  scope :offered, where(:state => 'offered')

  scope :type, lambda { |*types|
      where(:type => types.map { |type| type.is_a?(Class) ? type.to_s : "Invitation/#{type}".camelize })
  }

  belongs_to :user, :class_name => 'Personage'
  validates_presence_of :user_id

  belongs_to :site
  validates_presence_of :site_id

  def confirmations_count
    0
  end

  def acceptable?
    true
  end

end