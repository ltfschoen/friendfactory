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

  scope :notify?

  belongs_to :posting,
      :class_name  => 'Posting::Base',
      :foreign_key => 'posting_id'

  belongs_to :subscriber,
      :class_name  => 'Personage',
      :foreign_key => 'user_id'

  def notifiable?
    Rails.configuration.ignore_recipient_emailability || (subscriber.emailable? && subscriber.offline?)
  end

  def notified!
    touch(:notified_at)
  end

end
