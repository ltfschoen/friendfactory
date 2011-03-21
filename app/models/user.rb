class User < ActiveRecord::Base

  include ActiveRecord::Transitions

  attr_reader :current_site, :invitation_code

  validates_presence_of :first_name  
  validates_presence_of :current_site, :on => :create

  validates_each :invitation_code,
      :on => :create,
      :if => lambda { |user| current_site && current_site.invite_only? },
      :message => 'is not a valid membership code' do |user, attr, value|
    unless user.invitations.where(:code => value, :site_id => user.current_site.id).present?
      user.errors.add(attr)
    end
  end
  
  acts_as_authentic do |config|
    config.logged_in_timeout UserSession::InactivityTimeout
  end
  
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
  
  has_and_belongs_to_many :sites

  def current_site=(site)
    @current_site ||= site
    self.sites << @current_site unless site_ids.include?(site.id)
  end
      
  has_many :waves, :class_name => 'Wave::Base'
  has_many :profiles, :class_name => 'Wave::Profile'  
  
  def profile(site)
    profiles.joins(:sites).where(:sites => { :id => site.id }).order('updated_at desc').limit(1).first
  end
      
  def user_info(site)
    profile(site).profile_info
  end
    
  has_many :conversations,
      :class_name => 'Wave::Conversation',
      :order      => 'created_at desc' do        
    def site(site)
      if site.present?
        joins(:sites).where('sites_waves.site_id = ?', site.id)        
      end
    end
    def with(receiver, site)
      if receiver.present?
        site(site).where('resource_id = ? and resource_type = ?', receiver.id, User).order('updated_at desc').limit(1).first
      end
    end    
  end

  # Syntatic sugar:
  # <user1>.conversation.with.<user2>
  alias :conversation :conversations

  def create_conversation_with(receiver, site)
    if receiver.present? && site.present?
      wave = conversations.build
      wave.resource = receiver
      site.waves << wave
      wave.publish!
      wave
    end
  end

  has_many :inboxes, :class_name => 'Wave::Inbox'

  def inbox(site)
    if site.present?
      site.waves.
        where('type = ? and user_id = ?', Wave::Inbox, self.id).
        order('updated_at desc').limit(1).first
    end
  end
  
  def create_inbox(site)
    if site.present?
      inbox = inboxes.build
      inbox.waves = conversations.site(site)    
      site.waves << inbox
      inbox
    end
  end
  
  has_many :postings, :class_name => 'Posting::Base'
    
  has_many :invitations, :foreign_key => 'email', :primary_key => 'email'

  def invitations_attributes=(attrs)
    @invitation_code ||= attrs["0"]["code"] rescue nil
  end
    
  has_many :sponsorships, :class_name  => 'Invitation', :foreign_key => 'sponsor_id'
    
  has_many :friendships
  has_many :friends,  :through => :friendships
  has_many :inverse_friendships, :class_name => 'Friendship', :foreign_key => 'friend_id'
  has_many :admirers, :through => :inverse_friendships, :source => :user

  scope :online, :conditions => [ 'last_request_at >= ? and current_login_at is not null', (Time.now - UserSession::InactivityTimeout).to_s(:db) ]

  after_create do |user|
    create_profile(user.current_site)
  end

  def create_profile(site)
    profiles.new.tap { |profile| site.waves << profile }
  end
  
  def initialize_profile(site)
    create_profile(site) if profile(site).nil?
  end

  def avatar(site)
    profile(site).avatar
  end
  
  def self.online?(user)
    online.include?(user)
  end
  
  def online?
    User.online?(self)
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
