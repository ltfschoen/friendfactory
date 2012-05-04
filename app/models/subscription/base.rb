class Subscription::Base < ActiveRecord::Base

  include ActiveRecord::Transitions

  set_table_name :subscriptions

  state_machine do
    state :enabled
    state :disabled

    event :enable do
      transitions :to => :enabled, :from => [ :disabled ]
    end

    event :disable do
      transitions :to => :disabled, :from => [ :enabled ]
    end
  end

  scope :enabled, lambda {
    where(:state => :enabled)
  }

  scope :disabled, lambda {
    where(:state => :disabled)
  }

  scope :subscriber, lambda { |user|
    where(:user_id => user[:id])
  }

  scope :exclude, lambda { |subscription|
    subscription && subscription.persisted? ? where('`subscriptions`.`id` <> ?', subscription[:id]) : scoped
  }

  scope :exclude_subscriber, lambda { |user|
    user ? where('`subscriptions`.`user_id` <> ?', user[:id]) : scoped
  }

  scope :type, lambda { |*types|
    where(:type => types.map(&:to_s))
  }

  # Override
  scope :notify?

  belongs_to :resource, :polymorphic => true

  belongs_to :user,
      :class_name  => 'Personage',
      :foreign_key => 'user_id'

  alias :subscriber :user

  validates_presence_of \
      :user_id,
      :resource_id,
      :resource_type

  validates_uniqueness_of :user_id,
      :scope => [ :resource_id, :resource_type ]

  ###

  # Override
  def self.tally(subscriptions)
    subscriptions
  end

  def notifiable?
    Rails.configuration.ignore_recipient_emailability || (subscriber.emailable? && subscriber.offline?)
  end

  def notified!
    touch(:notified_at)
  end

  def related
    subscriber.subscriptions.type(self.class).exclude(self)
  end

end
