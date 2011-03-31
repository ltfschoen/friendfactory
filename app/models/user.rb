class User < ActiveRecord::Base

  include ActiveRecord::Transitions

  attr_accessor :invitation_code
  attr_accessor :enrollment_site
  attr_reader   :enrollment_profile

  validates_presence_of :enrollment_site, :on => :create

  validates_each :enrollment_site,
      :on => :update,
      :allow_nil => true do |user, attribute, value|    
    if user.sites.where(:id => value.id).present?
      user.errors.add(:base, 'Already a member of this site')
    end
  end  

  validates_each :invitation_code,
      :if => lambda { |user| user.enrollment_site.present? && user.enrollment_site.invite_only? } do |user, attribute, value|
    unless user.invitations.where(:code => value, :site_id => user.enrollment_site.id).present?
      user.errors.add(:base, "That email does not have an invite to this site with that invitation code")
    end
  end
    
  after_save :save_enrollment
  
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
  
  has_and_belongs_to_many :sites, :uniq => true, :before_add => :validate_enrollment_site

  has_many :waves, :class_name => 'Wave::Base'
  has_many :profiles, :class_name => 'Wave::Profile', :order => 'created_at desc'
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

  def validate_enrollment_site(site)
    raise "User already a member" if sites.where(:id => site.id).present?
  end
  
  def validate_associated_records_for_profiles
    if enrollment_site.present? && !enrollment_profile.try(:handle).present?
      errors.add(:handle, "can't be blank")
    end
  end

  def save_enrollment
    if enrollment_site.present? && sites << enrollment_site && enrollment_profile.sites << enrollment_site
      @enrollment_site, @enrollment_profile = nil, nil
    end
  end
  
  def self.new_user_with_enrollment(site, params)
    User.new(params).tap do |user|
      user.enrollment_site = site
    end
  end

  def enroll(site, handle, invitation_code = nil)
    self.enrollment_site = site
    self.handle = handle
    self.invitation_code = invitation_code
    self
  end
  

  # ===  Build assocations ===
    
  def handle=(handle)
    build_profile(:handle => handle)
  end

  def build_profile(attrs= {})
    @enrollment_profile = profiles.build(attrs).tap do |profile|
      profile.current_site = current_site
    end
  end
  

  # === Profile ===

  def profile(site = enrollment_site)
    if site == enrollment_site
      enrollment_profile      
    else
      profile = profiles.joins(:sites).where(:sites => { :id => site.id }).order('updated_at desc').limit(1).first
      profile.current_site = site if profile
      profile
    end
  end

  def handle(site = enrollment_site)
    profile(site).try(:handle)
  end
  
  def avatar(site)
    profile(site).avatar
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
  
  def self.online?(user)
    online.include?(user)
  end
  
  def online?
    User.online?(self)
  end
  
  def existing_record?
    !new_record?
  end
  
  def to_s
    email
  end
  
  def reset_password!
    reset_perishable_token!
  end
    
end
