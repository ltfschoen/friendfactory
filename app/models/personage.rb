class Personage < ActiveRecord::Base

  attr_accessible \
      :user,
      :persona,
      :profile,
      :avatar

  delegate \
      :email,
      :state,
      :roles,
      :admin?,
      :uid,
      :gid,
    :to => :user

  delegate \
      :handle,
      :first_name,
      :last_name,
      :dob,
      :location,
      :avatar,
      :avatar?,
      :avatar=,
    :to => :persona

  scope :default, where(:default => true).order('`updated_at` DESC').limit(1)

  belongs_to :user
  validates_presence_of :user

  belongs_to :persona, :class_name => 'Persona::Base', :autosave => true
  validates_presence_of :persona

  belongs_to :profile, :class_name => 'Wave::Base'
  validates_presence_of :persona

  def personages
    Personage.where(:user_id => user_id)
  end

  ### Waves

  has_many :bookmarks

  has_many :waves, :class_name => 'Wave::Base', :foreign_key => 'user_id' do
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
      if receiver.present? && site.present?
        # site(site).where('resource_id = ? and resource_type = ?', receiver.id, 'User').order('updated_at desc').limit(1).first
        site(site).where(:resource_id => receiver.id).order('updated_at DESC').limit(1).first
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

end
