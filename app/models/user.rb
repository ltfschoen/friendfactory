class User < ActiveRecord::Base

  include ActiveRecord::Transitions
  include ActiveModel::Validations

  # attr_accessor :enrollment_site
  attr_accessor :invitation_code
  attr_accessor :invitation_override

  attr_accessible :email,
      :handle,
      :age,
      :location,
      :password,
      :password_confirmation,
      :enrollment_site,
      :emailable,
      :invitation_code

  # TODO: delegate :handle, :age, :location, :to => :profile

  validates_presence_of :site

  # validates_presence_of :handle, :if => :enrollment_site_present?
  # validates_presence_of :age, :location, :if => :enrollment_site_present?

  # validate do |user|
  #   if user.new_record? || enrollment_site.present?
  #     user.validate_enrollment_site
  #     user.validate_invitation_code
  #     user.validate_invitation_code_state
  #   end
  # end

  # def enrollment_site_present?
  #   new_record? || enrollment_site.present?
  # end

  # def validate_enrollment_site
  #   return if enrollment_site.blank? || sites.where(:id => enrollment_site.id).empty?
  #   errors.add(:base, 'Already a member of this site')
  # end

  # def validate_invitation_code
  #   return if invitation_override || enrollment_site.blank?
  #   return if !enrollment_site.invite_only? || invitation_for_site(enrollment_site).present?
  #   errors.add(:invitation_code, 'is not valid')
  # end

  # def validate_invitation_code_state
  #   return if invitation_override || enrollment_site.blank?
  #   invitation = invitation_for_site(enrollment_site)
  #   return if invitation.nil? || invitation.offered?
  #   errors.add(:invitation_code, "has already been #{invitation_for_site(enrollment_site).current_state}")
  # end

  # after_save :perform_enrollment

  acts_as_authentic do |config|
    config.logged_in_timeout UserSession::InactivityTimeout
    config.validations_scope = :site_id
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

  belongs_to :account

  # has_and_belongs_to_many :sites, :uniq => true, :before_add => :raise_exception_if_already_enrolled
  belongs_to :site

  has_many :bookmarks

  has_many :waves, :class_name => 'Wave::Base' do
    def type(*types)
      where('type in (?)', types.map(&:to_s))
    end
    def site(site)
      joins('INNER JOIN `sites_waves` on `waves`.`id` = `sites_waves`.`wave_id`').
      where(:sites_waves => { :site_id => site.id })
    end
  end

  # has_many :profiles, :class_name => 'Wave::Profile'
  has_one :profile, :class_name => 'Wave::Profile'

  ### Conversations

  has_many :conversations, :class_name => 'Wave::Conversation' do
    def with(receiver, site)
      if receiver.present? && site.present?
        site(site).where('resource_id = ? and resource_type = ?', receiver.id, 'User').order('updated_at desc').limit(1).first
      end
    end
  end

  alias :conversation :conversations # Syntatic sugar <user1>.conversation.with.<user2>

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
  
  # def self.new_user_with_enrollment(site, params)
  #   User.new(params).tap do |user|
  #     user.enrollment_site = site
  #   end
  # end

  # def enroll(site, attrs)
  #   self.enrollment_site = site
  #   self.handle = attrs[:handle]
  #   self.age = attrs[:age]
  #   self.location = attrs[:location]
  #   self.invitation_code = attrs[:invitation_code]
  #   self.invitation_override = attrs[:invitation_override]
  #   self
  # end

  # def enroll!(*args)
  #   enroll(*args) && save!
  # end


  ### Enrollment Profile

  # def handle=(handle)
  #   enrollment_profile.handle = handle
  # end

  # def age=(age)
  #   enrollment_profile.age = age
  # end

  # def location=(location)
  #   enrollment_profile.location = location
  # end

  # def enrollment_profile
  #   @enrollment_profile ||= profiles.build
  # end

  def profile_attributes=(attributes)
    raise profile_attributes.inspect
  end

  ### Delegate to Profile

  # def profile(site = enrollment_site)
  #   raise "No site provided" if site.nil?
  #   if site == enrollment_site
  #     enrollment_profile
  #   else
  #     @cached_profiles ||= {}
  #     @cached_profiles[site.name.to_sym] ||= profiles.site(site).published.order('updated_at desc').limit(1).first
  #   end
  # end

  def handle(site = nil)
    delegate_to_profile_warning('handle') unless site.nil?
    profile.handle
  end

  def age(site = nil)
    delegate_to_profile_warning('age') unless site.nil?
    profile.age
  end

  def location(site = nil)
    delegate_to_profile_warning('location') unless site.nil?
    profile.location
  end

  def avatar(site)
    delegate_to_profile_warning('avatar') unless site.nil?
    profile.avatar
  end

  def first_name(site)
    delegate_to_profile_warning('first_name') unless site.nil?
    profile.first_name
  end

  def last_name(site)
    delegate_to_profile_warning('last_name') unless site.nil?
    profile.last_name
  end

  def full_name(site)
    delegate_to_profile_warning('full_name') unless site.nil?
    profile.full_name
  end
  
  def gender(site)
    delegate_to_profile_warning('gender') unless site.nil?
    profile.gender
  end
  
  def delegate_to_profile_warning(attribute)
    Rails.logger.warn("User##{attribute} called with site")
  end
  
  # TODO Delete this. Should not expose the resource relationship.. who cares
  # about a profile's resource?? The profile should expose the interesting
  # things diretly.
  # def user_info(site)
  #   profile(site).resource
  # end


  ### Invitations

  def self.find_by_invitation_code(invitation_code)
    if invitation_code.present?
      invitation_code.strip!
      invitations = Posting::Invitation.find_all_by_code(invitation_code)
      if invitations.length == 1
        invitation = invitations.first
        (invitation.invitee || User.new).tap do |user|
          user.email ||= invitation.email
          user.invitation_code = invitation_code
        end
      end
    end
  end

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

  # def perform_enrollment
  #   if enrollment_site.present?
  #     if (sites << enrollment_site) && (enrollment_profile.sites << enrollment_site)
  #       if enrollment_site.invite_only? && !invitation_override
  #         invitation = invitation_for_site(enrollment_site)
  #         invitation.accept! unless invitation.anonymous?
  #       end
  #       @enrollment_site, @enrollment_profile, @invitation_override = nil, nil, nil
  #     end
  #   end
  # end
    
  # def raise_exception_if_already_enrolled(site)
  #   raise "User already a member" if sites.where(:id => site.id).present?
  # end
  
  def create_invitation_wave_for_site(site)
    wave = Wave::Invitation.new.tap { |wave| wave.user = self }
    site.waves << wave && wave.publish!
    wave.reload
  end  
end
