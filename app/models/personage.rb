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
      :tag_list,
      :location_list,
      :biometric_list,
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

  scope :homeable, lambda { |site|
      type(:ambassador, :place, :community).
      joins(:profile).
      joins(:user).
      merge(Wave::Base.published).
      merge(Wave::Base.site(site)).
      merge(User.enabled)
  }

  scope :enabled, where(:state => :enabled)

  scope :exclude, lambda { |id| where('`personages`.`id` <> ?', id) }

  scope :sidebar_rollcall, lambda { |site, persona_type, exclude_id, limit|
      enabled.
      site(site).
      type(persona_type).
      joins(:profile).
      includes(:persona => :avatar).
      exclude(exclude_id).
      where('`personas`.`avatar_id` IS NOT NULL').
      limit(limit).
      order('`waves`.`updated_at` DESC')
  }

  accepts_nested_attributes_for :persona

  def persona_attributes=(attrs)
    if persona.nil?
      type = "Persona::#{(attrs.delete(:type) || 'base').titleize}"
      klass = type.constantize
      self.persona = klass.new(attrs)
    else
      if persona[:id] == attrs.delete('id').to_i
        persona.update_attributes(attrs)
      end
    end
  end

  def persona_type
    if persona
      persona[:type].demodulize.downcase
    end
  end

  def display_name
    [ persona_type.try(:titleize), handle ].compact.join(' ')
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
      profile[:user_id] = self.id
      profile.save
    end
  end

  ### Friendships

  public

  has_many :friendships,
      :foreign_key => 'user_id',
      :class_name  => 'Friendship::Base'

  has_many :friends, :through => :friendships do
    def type(*types)
      where(:friendships => { :type => types.map(&:to_s) })
    end
  end

  has_many :inverse_friendships,
      :foreign_key => '`friend_id`',
      :class_name  => 'Friendship::Base'

  has_many :inverse_friends,
      :through => :inverse_friendships,
      :source  => :user do
    def type(*types)
      where(:friendships => { :type => types.map(&:to_s) })
    end
  end

  alias :admirers :inverse_friends

  def toggle_poke(personage)
    return if personage[:id] == self[:id]
    if poke = friendships.type(Friendship::Poke).find_by_friend_id(personage[:id])
      poke.delete
      nil
    else
      poke = Friendship::Poke.new(:friend => personage)
      friendships << poke
      poke
    end
  end

  def has_friended?(personage_id, type)
    friendships.type(type).find_by_friend_id(personage_id).present?
  end

  def has_poked?(personage_id)
    has_friended?(personage_id, ::Friendship::Poke)
  end

  ### Waves

  public

  has_many :bookmarks

  has_many :waves,
      :class_name  => 'Wave::Base',
      :foreign_key => 'user_id' do
  end

  ### Conversations

  has_many :conversations, :class_name => 'Wave::Conversation', :foreign_key => 'user_id' do
    def with(receiver, site)
      if receiver && site
        site(site).find_by_resource_id(receiver[:id])
      end
    end
  end

  def conversation_with(receiver, site)
    conversations.with(receiver, site)
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

  def find_or_create_conversation_with(receiver, site)
    conversation_with(receiver, site) || create_conversation_with(receiver, site)
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
      :foreign_key => 'user_id',
      :class_name  => 'Invitation::Base'

  has_one :invitation_confirmation,
      :foreign_key => 'invitee_id',
      :class_name  => 'Invitation::Confirmation'

  # @invitations = personage.profile.postings.type(Posting::Invitation).order('`postings`.`created_at` DESC').limit(Wave::InvitationsHelper::MaximumDefaultImages)

  # has_many :received_invitations,
  #     :foreign_key => 'body',
  #     :primary_key => 'email',
  #     :class_name  => 'Posting::Invitation' do
  #   def site(site)
  #     where(:resource_id => site.id)
  #   end
  # end

  # def invitations_attributes=(attributes)
  #   raise attributes.inspect
  # end

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
