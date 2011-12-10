class User < ActiveRecord::Base

  include ActiveRecord::Transitions
  include ActiveModel::Validations

  attr_accessor :invitation_code

  attr_accessible :email,
      :person_attributes,
      :password,
      :password_confirmation,
      :emailable,
      :invitation_code

  # TODO: delegate :handle, :age, :location, :to => :profile

  validates_presence_of :site
  validates_presence_of :invitation_code,
      :on => :create,
      :if => lambda { site.present? && site.invite_only? }

  validate :invitation_code_offered?,
      :on => :create,
      :if => lambda { site.present? && site.invite_only? && invitation_code.present? }

  def invitation_code_offered?
    unless site.invitations.offered.find_by_code(invitation_code)
      errors.add(:invitation_code, 'is not valid')
    end
  end

  private :invitation_code_offered?

  after_initialize :build_empty_person
  after_initialize :set_email_address_from_invitation
  before_create :attach_to_account

  private

  def build_empty_person
    build_person if new_record? && person.nil?
  end

  def set_email_address_from_invitation
    if new_record?
      if site && site.invite_only?
        if invitation = site.invitations.offered.personal.find_by_code(invitation_code)
          self.email ||= invitation.email
        end
      end
    end
  end

  def attach_to_account
    self.account = Account.find_or_create_for_user(self) if account.nil?
  end

  public

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
      transitions :to => :disabled, :from => [ :enabled ], :on_transition => :unsubscribe!
    end
  end

  scope :online, lambda { { :conditions =>
      [ 'last_request_at >= ? and current_login_at is not null', (Time.now.utc - UserSession::InactivityTimeout).to_s(:db) ] } }

  scope :featured, where('`users`.`score` > 0')

  belongs_to :account
  belongs_to :site

  has_one :person
  accepts_nested_attributes_for :person

  has_one :profile, :class_name => 'Wave::Profile'

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

  after_create :invitation_code_accept!

  def invitation_code_accept!
    if site.invite_only? && invitation = site.invitations.offered.find_by_code(invitation_code)
      invitation.accept!
    end
  end

  private :invitation_code_accept!

  ### Conversations

  has_many :conversations, :class_name => 'Wave::Conversation' do
    def with(receiver, site)
      if receiver.present? && site.present?
        site(site).where('resource_id = ? and resource_type = ?', receiver.id, 'User').order('updated_at desc').limit(1).first
      end
    end
  end

  # Syntatic sugar <user1>.conversation.with.<user2>
  alias :conversation :conversations

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

  def inbox(site)
    conversations.site(site).chatty.published
  end

  ### Postings

  has_many :postings, :class_name => 'Posting::Base'

  has_many :invitations, :foreign_key => 'body', :primary_key => 'email', :class_name => 'Posting::Invitation' do
    def site(site)
      where(:resource_id => site.id)
    end
  end

  ### TODO: Delegate to Profile

  def handle(site = nil)
    delegate_to_profile_warning('handle') unless site.nil?
    person.handle
  end

  def age(site = nil)
    delegate_to_profile_warning('age') unless site.nil?
    person.age
  end

  def location(site = nil)
    delegate_to_profile_warning('location') unless site.nil?
    person.location
  end

  def avatar(site)
    delegate_to_profile_warning('avatar') unless site.nil?
    profile.avatar
  end

  def first_name(site)
    delegate_to_profile_warning('first_name') unless site.nil?
    person.first_name
  end

  def last_name(site)
    delegate_to_profile_warning('last_name') unless site.nil?
    person.last_name
  end

  def full_name(site)
    delegate_to_profile_warning('full_name') unless site.nil?
    person.full_name
  end

  def gender(site)
    delegate_to_profile_warning('gender') unless site.nil?
    person.gender
  end

  def delegate_to_profile_warning(attribute)
    Rails.logger.warn("User##{attribute} called with site")
  end

  private :delegate_to_profile_warning

  ### Invitations

  def find_or_create_invitation_wave_for_site(site)
    invitation_wave_for_site(site) || create_invitation_wave_for_site(site)
  end

  def find_invitation_wave_by_id(id)
    waves.type(Wave::Invitation).published.find_by_id(id)
  end

  def invitation_wave_for_site(site)
    waves.site(site).type(Wave::Invitation).published.limit(1).try(:first)
  end

  def create_invitation_wave_for_site(site)
    wave = Wave::Invitation.new.tap { |wave| wave.user = self }
    site.waves << wave && wave.publish!
    wave.reload
  end

  private :create_invitation_wave_for_site

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

  def subscribe!
    update_attribute(:emailable, true)
  end

  def unsubscribe!
    update_attribute(:emailable, false)
  end

  # ===

  def uid
    "uid-#{self.id}"
  end

  def roles
    "gid-admin" if self.admin?
  end

end
