class Account < ActiveRecord::Base

  include ActiveRecord::Transitions

  has_many :users

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

  def self.find_or_create_for_user(user)
    if user.email && existing_user = User.where(:email => user.email).order('"users"."updated_at" DESC').limit(1).first
      existing_user.account
    else
      Account.create
    end
  end

end
