class User < ActiveRecord::Base
  
  include AASM
  
  aasm_column        :status
  aasm_initial_state :welcomed
  aasm_state         :welcomed
  
  acts_as_authentic do |config|
    config.logged_in_timeout = 30.minutes
  end

  has_many :received_messages, :class_name => Message.name, :foreign_key => 'receiver_id', :order => 'created_at desc'
  has_many :sent_messages,     :class_name => Message.name, :foreign_key => 'sender_id',   :order => 'created_at desc'
  
  has_many :senders,    :through => :received_messages, :source => :sender,   :uniq => true
  has_many :recipients, :through => :sent_messages,     :source => :receiver, :uniq => true

  def require_password?
    true
  end
  
  def avatar
    'default_portrait_image.gif'
  end
  
  def handle
    self.handle || full_name
  end
  
  def full_name
    [ self.first_name, self.last_name ].compact * ' '
  end
  
end
