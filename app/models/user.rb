class User < ActiveRecord::Base
  
  DefaultMessagePeriod = 10.days
  
  include AASM
  
  aasm_column        :status
  aasm_initial_state :welcomed
  aasm_state         :welcomed
  
  acts_as_authentic do |config|
    config.logged_in_timeout = 30.minutes
  end

  has_many :received_messages, :class_name => Message.name, :foreign_key => 'receiver_id', :order => 'created_at desc' do
    def since(period)
      find :all, :conditions => [ 'created_at >= ?', (Time.now - period).to_s(:db) ], :include => [ :sender ]
    end
  end
  
  has_many :sent_messages, :class_name => Message.name, :foreign_key => 'sender_id', :order => 'created_at desc' do
    def since(period)
      find :all, :conditions => [ 'created_at >= ?', (Time.now - period).to_s(:db) ]
    end
  end
  
  has_many :senders,    :through => :received_messages, :source => :sender,   :uniq => true
  has_many :recipients, :through => :sent_messages,     :source => :receiver, :uniq => true

  def message_threads(period = DefaultMessagePeriod)    
    # Returns an array of user's message threads. Each thread is an
    # array of two elements: the leaf message, and an array of the
    # leaf node ancestors.
    
    # First, get the user's received leaf messages
    messages = self.received_messages.since(period).inject([]) do |messages, message|
      message.children.empty? ? messages << [ message, message.ancestors ] : messages
    end
    
    # Then, get the user's sent leaf messages
    self.sent_messages.since(period).inject(messages) do |messages, message|
      message.children.empty? ? messages << [ message, message.ancestors ] : messages
    end        
  end

  def require_password?
    true
  end

  def avatar
    'portrait_default.png'
  end
  
  def handle
    self.handle || full_name
  end
  
  def full_name
    [ self.first_name, self.last_name ].compact * ' '
  end
  
  def to_s
    "{ :id => #{self.id}, :full_name => #{full_name} }"
  end
  
  def send_message(attrs = {})
    self.sent_messages.create(attrs)
  end
    
end
