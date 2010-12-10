class User < ActiveRecord::Base

  acts_as_authentic do |config|
    config.logged_in_timeout = UserSession::Timeout
  end

  validates_presence_of :first_name

  include AASM
  aasm_column        :status
  aasm_initial_state :welcomed
  aasm_state         :welcomed

  has_one  :user_info
  
  has_many :waves,    :class_name => 'Wave::Base'
  has_one  :profile,  :class_name => 'Wave::Profile'  
  has_many :conversations,
      :class_name => 'Wave::Conversation',
      :order      => 'created_at desc' do
    def with(receiver)
      where(:resource_id => receiver.id).limit(1).first if receiver.present?
    end
  end

  # Syntatic sugar:
  # <user1>.conversation.with.<user2>
  alias :conversation :conversations

  has_one  :inbox, :class_name => 'Wave::Inbox'
      
  has_many :postings, :class_name => 'Posting::Base'
  
  has_many :friendships
  has_many :friends,  :through => :friendships
  has_many :inverse_friendships, :class_name => 'Friendship', :foreign_key => 'friend_id'
  has_many :admirers, :through => :inverse_friendships, :source => :user

  scope :online, :conditions => [ 'last_request_at >= ? and current_login_at is not null', (Time.now - UserSession::Timeout).to_s(:db) ]

  after_create do
    if self.profile.nil?
      profile = create_profile
    end
  end

  def avatar
    profile.avatar
  end
  
  def self.online?(user)
    online.include?(user)
  end
  
  def online?
    User.online?(self)
  end
  
  def create_conversation_with(receiver)
    if receiver.present?
      wave = conversations.build
      wave.resource = receiver
      wave.save
      wave
    end
  end
  
  def has_friend?(buddy)
    self.friendships.map(&:friend_id).include?(buddy.id)
  end

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
    lname = self[:last_name].humanize if self[:last_name].present?
    [ first_name, lname ].compact * ' '
  end
  
  def first_name
    self[:first_name].humanize if self[:first_name].present?
  end
  
  def to_s
    "{ :id => #{self.id}, :full_name => #{full_name} }"
  end
  
  def reset_password!
    reset_perishable_token!
  end
    
end
