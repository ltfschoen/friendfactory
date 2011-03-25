class User < ActiveRecord::Base

  include ActiveRecord::Transitions

  attr_reader :invitation_code, :recently_added_site, :recently_added_profile

  validates_presence_of :recently_added_profile, :on => :create
  
  validates_each :invitation_code,
      :if => lambda { |user| user.recently_added_site && user.recently_added_site.invite_only? },
      :message => 'is not a valid invitation code' do |user, attribute, value|
    unless user.invitations.where(:code => value, :site_id => user.recently_added_site.id).present?
      user.errors.add(attribute)
    end
  end
    
  validates_associated :profiles
  
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
  
  scope :online, lambda { { :conditions =>
      [ 'last_request_at >= ? and current_login_at is not null', (Time.now - UserSession::InactivityTimeout).to_s(:db) ] } }
  
  has_and_belongs_to_many :sites, :uniq => true,
      :before_add => :validate_not_already_on_site,
      :after_add  => :set_recently_added_site

  has_many :waves, :class_name => 'Wave::Base'  
  has_many :profiles, :class_name => 'Wave::Profile'    
  has_many :inboxes, :class_name => 'Wave::Inbox'
  
  has_many :conversations, :class_name => 'Wave::Conversation', :order => 'created_at desc' do        
    def site(site)
      joins(:sites).where('sites_waves.site_id = ?', site.id) if site.present?
    end
    def with(receiver, site)
      site(site).where('resource_id = ? and resource_type = ?', receiver.id, User).order('updated_at desc').limit(1).first if receiver.present?
    end    
  end

  # Syntatic sugar:
  # <user1>.conversation.with.<user2>
  alias :conversation :conversations

  has_many :postings, :class_name => 'Posting::Base'
  has_many :invitations, :foreign_key => 'email', :primary_key => 'email'    
  has_many :sponsorships, :class_name  => 'Invitation', :foreign_key => 'sponsor_id'

  # has_many :friendships
  # has_many :friends,  :through => :friendships
  # has_many :inverse_friendships, :class_name => 'Friendship', :foreign_key => 'friend_id'
  # has_many :admirers, :through => :inverse_friendships, :source => :user

  def validate_not_already_on_site(site)
    raise "User already on site" if sites.where(:id => site.id).present?
  end

  def set_recently_added_site(site)
    raise "No profile available to add to site" unless defined?(@recently_added_profile)
    @recently_added_profile.sites << site
    @recently_added_site = site
  end


  # ===  Build assocations ===
  
  def invitation=(attrs)
    @invitation_code = attrs["code"]
  end
    
  def profile=(attrs)
    build_profile(attrs)
  end

  def build_profile(attrs)
    @recently_added_profile = profiles.build(attrs)
  end
  

  # === Profile ===

  def profile(site)
    profiles.joins(:sites).where(:sites => { :id => site.id }).order('updated_at desc').limit(1).first
  end
  
  def avatar(site)
    profile(site).avatar
  end
  
  def handle(site)
    profile(site).handle
  end
  
  def first_name(site)
    profile(site).first_name
  end
  
  def last_name(site)
    profile(site).last_name
  end
  
  def full_name(site)
    profile(site).full_name
  end
  
  def gender(site)
    profile(site).gender
  end
  
  
  # TODO Delete this. Should not expose the resource relationship.. who cares
  # about a profile's resource?? The profile should expose the interesting
  # things diretly.
  def user_info(site)
    profile(site).resource
  end


  # === Conversations ===
  
  def create_conversation_with(receiver, site)
    if receiver.present? && site.present?
      wave = conversations.build
      wave.resource = receiver
      site.waves << wave
      wave.publish!
      wave
    end
  end

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


  # ===
  
  def self.find_or_create_with_profile(params)
    existing_user_with_profile(params) || create_user_with_profile(params)
  end
  
  def self.online?(user)
    online.include?(user)
  end
  
  def online?
    User.online?(self)
  end
  
  def to_s
    "{ :id => #{self.id}, :full_name => #{full_name} }"
  end
  
  def reset_password!
    reset_perishable_token!
  end
  
  private
  
  def self.existing_user_with_profile(params)
    if user = User.find_by_email(params[:email])
      user.build_profile(params[:profile])
      user
    end
  end
  
  def self.create_user_with_profile(params)
    User.new(params)    
  end
  
end
