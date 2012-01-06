class User < ActiveRecord::Base

  include ActiveRecord::Transitions
  include ActiveModel::Validations

  attr_accessor :invitation_code

  attr_accessible \
      :email,
      :person_attributes,
      :password,
      :password_confirmation,
      :emailable,
      :invitation_code,
      :invitations_attributes

  delegate \
      :handle,
      :age,
      :dob,
      :location,
      :first_name,
      :last_name,
      :avatar,
      :avatar?,
    :to => :persona

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

  scope :online, lambda {{ :conditions =>
      [ 'last_request_at >= ? and current_login_at is not null', (Time.now.utc - UserSession::InactivityTimeout).to_s(:db) ] }}

  scope :featured, where('`users`.`score` > 0')

  scope :role, lambda { |*role_name| joins(:role).where(:roles => { :name => role_name }) }


  ### Site

  belongs_to :site
  validates_presence_of :site


  ### Role && Persona

  belongs_to :role
  validates_presence_of :role

  has_one :persona, :class_name => 'Persona::Base'
  validates_presence_of :persona

  accepts_nested_attributes_for :persona

  alias :person :persona

  after_initialize :initialize_role_and_persona

  before_update :update_persona_type

  ::Role.all.each do |role|
    define_method("#{role.name}?".to_sym) do
      role_id == role.id
    end
  end

  alias :admin? :administrator?

  private

  def initialize_role_and_persona
    if new_record?
      initialize_role
      initialize_persona
    end
  end

  def initialize_role
    if role_id.nil?
      self.role = Role.default
    end
  end

  def initialize_persona
    if persona.nil?
      self.persona = role.default_persona_type.constantize.new
    end
  end

  def update_persona_type
    if role_id_changed?
      self.persona[:type] = role.default_persona_type
    end
  end


  ### Profile

  public

  has_one :profile,
      :class_name => 'Wave::Base',
      :autosave   => true

  before_create :build_profile
  before_update :update_profile_type

  private

  def build_profile
    self.profile = role.default_profile_type.constantize.new(:sites => [ site ], :state => :published)
  end

  def update_profile_type
    if role_id_changed?
      self.profile[:type] = role.default_profile_type
    end
  end


  ### Account

  public

  belongs_to :account

  before_create :attach_to_account

  def attach_to_account
    if account.nil?
      self.account = Account.find_or_create_for_user(self)
    end
  end

  private :attach_to_account


  ### Waves

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


  ### Invitations

  has_many :invitations,
      :foreign_key => 'body',
      :primary_key => 'email',
      :class_name  => 'Posting::Invitation' do
    def site(site)
      where(:resource_id => site.id)
    end
  end

  def invitations_attributes=(attributes)
    raise attributes.inspect
  end

  validates_presence_of :invitation_code,
      :on => :create,
      :if => lambda { site.present? && site.invite_only? }

  validate :invitation_code_offered?,
      :on => :create,
      :if => lambda { site.present? && site.invite_only? && invitation_code.present? }

  after_initialize :set_email_address_from_invitation

  after_create :accept_invitation_code

  def find_or_create_invitation_wave_for_site(site)
    invitation_wave_for_site(site) || create_invitation_wave_for_site(site)
  end

  def find_invitation_wave_by_id(id)
    waves.type(Wave::Invitation).published.find_by_id(id)
  end

  def invitation_wave_for_site(site)
    waves.site(site).type(Wave::Invitation).published.limit(1).try(:first)
  end

  private

  def invitation_code_offered?
    unless site.invitations.offered.find_by_code(invitation_code)
      errors.add(:invitation_code, 'is not valid')
    end
  end

  def set_email_address_from_invitation
    if new_record? && site && site.invite_only?
      if invitation = site.invitations.offered.personal.find_by_code(invitation_code)
        self.email ||= invitation.email
      end
    end
  end

  def accept_invitation_code
    if site.invite_only? &&
        invitation = site.invitations.offered.find_by_code(invitation_code)
      invitation.accept!
    end
  end

  def create_invitation_wave_for_site(site)
    wave = Wave::Invitation.new.tap { |wave| wave.user = self }
    site.waves << wave && wave.publish!
    wave.reload
  end


  ###

  public

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

  def uid
    "uid-#{self.id}"
  end

  def roles
    "gid-admin" if self.admin?
  end

end
