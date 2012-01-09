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

  has_many :personages

  accepts_nested_attributes_for :personages

  def default_personage
    personages.default.first
  end

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
