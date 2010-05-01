class User < ActiveRecord::Base
  
  include AASM
  
  aasm_column        :status
  aasm_initial_state :welcomed
  aasm_state         :welcomed
  
  acts_as_authentic do |config|
    config.logged_in_timeout = 30.minutes
  end
  
  has_one  :info,     :class_name => 'UserInfo'
  
  has_many :waves,    :class_name => 'Wave::Base'
  has_one  :profile,  :class_name => 'Wave::Profile'  
  has_many :postings, :class_name => 'Posting::Base'
  
  has_many :friendships
  has_many :inverse_friendships,
      :class_name  => 'Friendship',
      :foreign_key => 'friend_id'

  has_many :friends,  :through => :friendships            
  has_many :buddies,  :through => :friendships
  has_many :admirers, :through => :inverse_friendships, :source => :user

  # DefaultMessagePeriod = 10.days
  
  # has_many :received_messages, :class_name => Message.name, :foreign_key => 'receiver_id', :order => 'created_at desc' do
  #   def since(period)
  #     find :all, :conditions => [ 'created_at >= ?', (Time.now - period).to_s(:db) ], :include => [ :sender ]
  #   end
  # end
  
  # has_many :sent_messages, :class_name => Message.name, :foreign_key => 'sender_id', :order => 'created_at desc' do
  #   def since(period)
  #     find :all, :conditions => [ 'created_at >= ?', (Time.now - period).to_s(:db) ]
  #   end
  # end
  
  # has_many :senders,    :through => :received_messages, :source => :sender,   :uniq => true
  # has_many :recipients, :through => :sent_messages,     :source => :receiver, :uniq => true

  # def message_threads(period = DefaultMessagePeriod)    
  #   # Returns an array of user's message threads. Each thread is an
  #   # array of two elements: the leaf message, and an array of the
  #   # leaf node ancestors.
  #   
  #   # First, get the user's received leaf messages
  #   messages = self.received_messages.since(period).inject([]) do |messages, message|
  #     message.children.empty? ? messages << [ message, message.ancestors ] : messages
  #   end
  #   
  #   # Then, get the user's sent leaf messages
  #   self.sent_messages.since(period).inject(messages) do |messages, message|
  #     message.children.empty? ? messages << [ message, message.ancestors ] : messages
  #   end        
  # end

  # def send_message(attrs = {})
  #   self.sent_messages.create(attrs)
  # end

  def handle
    self.handle || full_name
  end
  
  def full_name
    [ self[:first_name].humanize, self[:last_name].humanize ].compact * ' '
  end
  
  def first_name
    self[:first_name].humanize
  end
  
  def to_s
    "{ :id => #{self.id}, :full_name => #{full_name} }"
  end
    
end
