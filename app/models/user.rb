class User < ActiveRecord::Base

  include ActiveRecord::Transitions
  include ActiveModel::Validations

  attr_accessor :invitation_code

  attr_accessible \
      :email,
      :password,
      :password_confirmation,
      :emailable,
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
      transitions :to => :disabled, :from => [ :enabled ], :on_transition => :unsubscribe!
    end
  end

  scope :online, lambda {{ :conditions =>
      [ 'last_request_at >= ? and current_login_at is not null', (Time.now.utc - UserSession::InactivityTimeout).to_s(:db) ] }}

  scope :featured, where('`users`.`score` > 0')

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

  ### Personage

  has_many :personages

  has_one :default_personage,
      :class_name => 'Personage',
      :order      => '`default` DESC, `created_at` ASC'

  accepts_nested_attributes_for :default_personage

  def default_personage_attributes=(attrs)
    attrs[:persona_attributes].merge!(:type => 'person')
    build_default_personage(attrs.merge(:default => true))
  end

  ### Account

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

  def self.uid(id)
    "uid-#{id}" if id
  end

  def uid
    User.uid(id)
  end

  def gid
    self.admin? ? 'gid-admin' : 'gid-user'
  end

end
