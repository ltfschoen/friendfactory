class User < ActiveRecord::Base

  include ActiveRecord::Transitions
  include ActiveModel::Validations

  attr_accessor :invitation_code

  attr_accessible \
      :email,
      :password,
      :password_confirmation,
      :default_personage_attributes,
      :current_login_at,
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
      transitions :to => :disabled, :from => [ :enabled ]
    end
  end

  scope :online, lambda {{ :conditions =>
      [ 'last_request_at >= ? and current_login_at is not null', (Time.now.utc - UserSession::InactivityTimeout).to_s(:db) ] }}

  scope :persona, lambda { |*role_names| joins(:personages => :persona).
      where(:personages => {
        :personas => {
          :type => role_names.map { |role_name| "persona/#{role_name}".camelize }
        }
      })
  }

  scope :enabled, where(:state => :enabled)

  ### Site

  belongs_to :site

  validates_presence_of :site

  validate :email_domain, :if => lambda { |user|
      user.site && user.site.email_domain_regex.present?
  }

  private

  def email_domain
    unless email =~ /#{site.email_domain_regex}/
      domain_display_name = site.email_domain_display_name
      domain_display_name = %w(a e i o u).include?(domain_display_name[0].downcase) ? "an #{domain_display_name}" : "a #{domain_display_name}"
      errors.add(:email, "must be from #{domain_display_name} domain")
    end
  end

  ### Personage

  public

  has_many :personages

  has_one :default_personage,
      :class_name => 'Personage',
      :order      => '`default` DESC, `created_at` ASC'

  accepts_nested_attributes_for :default_personage

  def default_personage_attributes=(attrs)
    if default_personage.nil?
      attrs[:persona_attributes].merge!(:type => 'Persona::Person', :emailable => true)
      build_default_personage(attrs.merge(:default => true))
    else
      default_personage.update_attributes(attrs)
    end
  end

  ### Account

  belongs_to :account

  before_create :attach_to_account

  private

  def attach_to_account
    if account.nil?
      self.account = Account.find_or_create_for_user(self)
    end
  end

  ### Invitation Code

  public

  validates_presence_of :invitation_code,
      :on => :create,
      :if => lambda { site && site.invite_only? }

  validate :invitation_code_offered?,
      :on => :create,
      :if => lambda { site && site.invite_only? && invitation_code.present? }

  after_initialize :set_email_address_from_invitation

  def accept_invitation
    case
    when site.nil?
      false
    when (!site.invite_only?)
      true
    when invitation = site.invitations.offered.find_by_code(invitation_code)
      invitation.set_invitee_personage(default_personage)
      invitation.accept!
    else
      false
    end
  end

  private

  def set_email_address_from_invitation
    if new_record? && email.nil?
      if site && site.invite_only? && invitation = site.invitations.type(:personal).offered.find_by_code(invitation_code)
        self[:email] = invitation.email
      end
    end
  end

  def invitation_code_offered?
    unless site.invitations.offered.find_by_code(invitation_code)
      errors.add(:invitation_code, 'is not valid')
    end
  end

  ###

  public

  def update_attributes_with_role(attrs, role = {})
    if attrs.present?
      admin = attrs.delete(:admin)
      state = attrs.delete(:state)
      update_attributes_without_role(attrs)
      if role[:as] == :admin
        update_attribute(:admin, admin) if admin.present?
        self.send(state.to_sym) if state.present?
      end
    end
  end

  alias_method_chain :update_attributes, :role

  def self.online?(user)
    online.include?(user)
  end

  def online?
    User.online?(self)
  end

  def offline?
    !online?
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

  def gid
    self.admin? ? 'gid_admin' : 'gid_user'
  end

end
