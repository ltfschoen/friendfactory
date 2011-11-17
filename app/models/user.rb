class User < ActiveRecord::Base

  include ActiveRecord::Transitions
  include ActiveModel::Validations

  attr_accessor :invitation_code
  attr_accessor :enrollment_site
  attr_reader   :enrollment_profile
  attr_accessor :invitation_override

  attr_accessible :email, :handle, :password, :password_confirmation, :enrollment_site, :emailable, :invitation_code

  validates_presence_of :enrollment_site, :on => :create

  validate do |user|
    if user.new_record? || enrollment_site.present?
      user.validate_enrollment_site
      user.validate_invitation_code
      user.validate_invitation_code_state
      user.validate_associated_records_for_profiles
    end
  end
  
  def validate_enrollment_site
    return if enrollment_site.blank? || sites.where(:id => enrollment_site.id).empty?
    errors.add(:base, 'Already a member of this site')
  end
    
  def validate_invitation_code
    return if invitation_override || enrollment_site.blank?
    return if !enrollment_site.invite_only? || invitation_for_site(enrollment_site).present?
    errors.add(:base, "Your invite code doesn't seem to be valid")
  end
  
  def validate_invitation_code_state
    return if invitation_override || enrollment_site.blank?
    invitation = invitation_for_site(enrollment_site)    
    return if invitation.nil? || invitation.offered?
    errors.add(:base, "That invite code has already been previously #{invitation_for_site(enrollment_site).current_state}")
  end

  def validate_associated_records_for_profiles
    return if enrollment_profile.present? && enrollment_profile.handle.present?
    errors.add_to_base("First name can't be blank")
  end

  validates_uniqueness_of :email

  after_save :perform_enrollment

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
      transitions :to => :disabled, :from => [ :enabled ], :on_transition => :disable_email!
    end
  end
  
  scope :online, lambda { { :conditions =>
      [ 'last_request_at >= ? and current_login_at is not null', (Time.now.utc - UserSession::InactivityTimeout).to_s(:db) ] } }
  
  has_and_belongs_to_many :sites, :uniq => true, :before_add => :raise_exception_if_already_enrolled

  has_many :waves, :class_name => 'Wave::Base' do
    def type(*types)
      where('type in (?)', types.map(&:to_s))
    end
    def site(site)
      joins('INNER JOIN `sites_waves` on `waves`.`id` = `sites_waves`.`wave_id`').
      where(:sites_waves => { :site_id => site.id })
    end
  end

  has_many :profiles, :class_name => 'Wave::Profile'


  ### Conversation Waves

  has_many :conversations, :class_name => 'Wave::Conversation' do
    def with(receiver, site)
      if receiver.present? && site.present?
        site(site).where('resource_id = ? and resource_type = ?', receiver.id, 'User').order('updated_at desc').limit(1).first
      end
    end
  end

  alias :conversation :conversations # Syntatic sugar <user1>.conversation.with.<user2>

  has_many :bookmarks

  def conversation_with(receiver, current_site)
    conversation.with(receiver, current_site) || create_conversation_with(receiver, current_site)
  end

  def create_conversation_with(receiver, site)
    if receiver.present? && site.present?
      wave = conversations.build
      wave.resource = receiver
      site.waves << wave
      wave.publish!
      wave
    end
  end


  ### Postings

  has_many :postings, :class_name => 'Posting::Base'

  has_many :invitations, :foreign_key => 'body', :primary_key => 'email', :class_name => 'Posting::Invitation' do
    def site(site)
      where(:resource_id => site.id)
    end
  end

  ### Social Graph

  # has_many :friendships, :class_name => 'Friendship::Base'
  # has_many :friends, :through => :friendships

  # def toggle_friendship(profile)
  #   # return false if self.id == profile.user_id
  #   (is_a_friend = friends.include?(profile)) ? friends.delete(profile) : friends << profile
  #   !is_a_friend
  # end
  
  def inbox(site)
    conversations.site(site).chatty.published
  end
  
  def self.find_by_invitation_code(invitation_code)
    invitations = Posting::Invitation.find_all_by_code(invitation_code)    
    if invitations.length == 1
      invitation = invitations.first
      (invitation.invitee || User.new).tap do |user|
        user.handle = user.profiles.first.try(:handle)
        user.email ||= invitation.email
        user.invitation_code = invitation_code
      end
    end
  end
  
  def self.new_user_with_enrollment(site, params)
    User.new(params).tap do |user|
      user.enrollment_site = site
    end
  end

  def enroll(site, handle, invitation_code = nil, invitation_override = false)
    self.tap do |user|
      user.enrollment_site = site
      user.handle = handle
      user.invitation_code = invitation_code
      user.invitation_override = invitation_override
    end
  end
  
  def enroll!(*args)
    enroll(*args) && save!
  end
  

  # ===  Build assocations ===
    
  def handle=(handle)
    build_profile(:handle => handle)
  end

  def build_profile(attrs = {})
    @enrollment_profile = profiles.build(attrs)
  end
  

  # === Profile ===

  def profile(site = enrollment_site)
    raise "No site provided" if site.nil?
    if site == enrollment_site
      enrollment_profile      
    else
      @cached_profiles ||= {}
      @cached_profiles[site.name.to_sym] ||= profiles.site(site).published.order('updated_at desc').limit(1).first
    end
  end

  def handle(site = enrollment_site)
    profile(site).try(:handle)
  end
  
  def avatar(site)
    @avatar ||= profile(site).avatar
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


  # == Invitations

  def find_or_create_invitation_wave_for_site(site)
    invitation_wave_for_site(site) || create_invitation_wave_for_site(site)
  end
  
  def find_invitation_wave_by_id(id)
    waves.type(Wave::Invitation).published.find_by_id(id)
  end

  def invitation_for_site(site)
    invitations.site(site).where(:subject => invitation_code).order('created_at desc').limit(1).try(:first) ||
        site.invitations.anonymous(invitation_code)
  end

  def invitation_wave_for_site(site)
    waves.site(site).type(Wave::Invitation).published.limit(1).try(:first)
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

  def disable_email!
    update_attribute(:emailable, false)
  end

  def subscribe!
    update_attribute(:emailable, true)
  end

  def unsubscribe!
    update_attribute(:emailable, false)
  end

  # ===

  def uid
    "u#{self.id}"
  end

  def roles
    "admin" if self.admin?
  end

  # ===

  private

  def perform_enrollment
    if enrollment_site.present?
      if (sites << enrollment_site) && (enrollment_profile.sites << enrollment_site)
        if enrollment_site.invite_only? && !invitation_override
          invitation = invitation_for_site(enrollment_site)
          invitation.accept! unless invitation.anonymous?
        end
        @enrollment_site, @enrollment_profile, @invitation_override = nil, nil, nil
      end
    end
  end
    
  def raise_exception_if_already_enrolled(site)
    raise "User already a member" if sites.where(:id => site.id).present?
  end
  
  def create_invitation_wave_for_site(site)
    wave = Wave::Invitation.new.tap { |wave| wave.user = self }
    site.waves << wave && wave.publish!
    wave.reload
  end  
end
