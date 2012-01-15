class Personage < ActiveRecord::Base

  include ActiveRecord::Transitions

  set_inheritance_column nil

  attr_accessible \
      :persona_attributes,
      :avatar,
      :emailable,
      :default

  delegate \
      :site,
      :email,
      :admin?,
      :uid,
      :gid,
      :emailable?,
      :emailable=,
      :current_login_at,
      :last_login_at,
      :online?,
    :to => :user

  delegate \
      :handle,
      :first_name,
      :last_name,
      :dob,
      :age,
      :description,
      :location,
      :avatar,
      :avatar?,
      :avatar=,
    :to => :persona

  state_machine do
    state :disabled
    state :enabled

    event :enable do
      transitions :to => :enabled, :from => [ :disabled ]
    end
  end

  belongs_to :user
  belongs_to :persona, :class_name => 'Persona::Base', :autosave => true
  belongs_to :profile, :class_name => 'Wave::Base'

  scope :site, lambda { |site|
      joins(:user).
      where(:users => { :site_id => site.id })
  }

  scope :user, lambda { |user|
      where(:user_id => user.id)
  }

  scope :type, lambda { |*types|
      joins(:persona).
      merge(Persona::Base.type(*types))
  }

  scope :wave, lambda { |wave|
      select('distinct `personages`.*').
      joins(:postings => :waves).
      joins(:persona).
      where(:postings => { :waves => { :id => wave.id }}).
      merge(Posting::Base.published).
      merge(Persona::Base.has_avatar)
  }

  scope :home_users, lambda { |site|
      type(:ambassador, :place, :community).
      joins(:profile).
      joins(:user).
      merge(Wave::Base.published).
      merge(Wave::Base.site(site)).
      merge(User.enabled)
  }

  scope :enabled, where(:state => :enabled)

  accepts_nested_attributes_for :persona

  def persona_attributes=(attrs)
    if persona.nil?
      type = "Persona::#{(attrs.delete(:type) || 'base').titleize}"
      klass = type.constantize
      self.persona = klass.new(attrs)
    else
      persona.update_attributes(attrs)
    end
  end

  def persona_type
    if persona
      persona[:type].demodulize.downcase
    end
  end

  def description
    handle
  end

  def description_with_id
    [ description, "(#{id})" ].compact.join(' ')
  end

  def display_name
    [ type, handle ] * ' - '
  end

  ### Profile

  before_create :initialize_profile

  after_create  :initialize_profile_user_id

  private

  def initialize_profile
    if persona && profile.nil?
      self.profile = persona.default_profile_type.constantize.create do |wave|
        wave.sites.push(site)
        wave.state = :published
      end
    end
  end

  def initialize_profile_user_id
    if profile && profile[:user_id].nil?
      profile[:user_id] = self
      profile.save
    end
  end

  ### Waves

  public

  has_many :bookmarks

  has_many :waves,
      :class_name  => 'Wave::Base',
      :foreign_key => 'user_id' do
    # def type(*types)
    #   where('type in (?)', types.map(&:to_s))
    # end
    # def site(site)
    #   joins('INNER JOIN `sites_waves` on `waves`.`id` = `sites_waves`.`wave_id`').
    #   where(:sites_waves => { :site_id => site.id })
    # end
  end

  ### Conversations

  has_many :conversations, :class_name => 'Wave::Conversation', :foreign_key => 'user_id' do
    def with(receiver, site)
      if receiver && site
        site(site).where(:resource_id => receiver.id).order('updated_at DESC').limit(1).first
      end
    end
  end

  def find_or_create_conversation_with(receiver, current_site)
    conversations.with(receiver, current_site) || create_conversation_with(receiver, current_site)
  end

  def create_conversation_with(receiver, site)
    if receiver && site
      wave = conversations.build
      wave.resource = receiver
      site.waves << wave
      wave.publish!
      wave
    end
  end

  private :create_conversation_with

  def inbox(site)
    conversations.site(site).chatty.published
  end

  ### Postings

  has_many :postings,
      :class_name  => 'Posting::Base',
      :foreign_key => 'user_id'

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

  # validates_presence_of :invitation_code,
  #     :on => :create,
  #     :if => lambda { site.present? && site.invite_only? }

  # validate :invitation_code_offered?,
  #     :on => :create,
  #     :if => lambda { site.present? && site.invite_only? && invitation_code.present? }

  # after_initialize :set_email_address_from_invitation

  # after_create :accept_invitation_code

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

  # def set_email_address_from_invitation
  #   if new_record? && site && site.invite_only?
  #     if invitation = site.invitations.offered.personal.find_by_code(invitation_code)
  #       self.email ||= invitation.email
  #     end
  #   end
  # end

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

end
