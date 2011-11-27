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

  def self.find_or_create_by_email(email)
    if user = User.where(:email => email).order('updated_at desc').limit(1).first
      user.account
    else
      Account.new(email)
    end
  end

end