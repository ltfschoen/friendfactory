class Wave::Profile < Wave::Base

  extend Forwardable
  
  validates_presence_of :handle, :unless => :first_name
  
  has_and_belongs_to_many :avatars,
      :class_name              => 'Posting::Avatar',
      :foreign_key             => 'wave_id',
      :association_foreign_key => 'posting_id',
      :join_table              => 'postings_waves',
      :order                   => 'updated_at desc',
      :after_add               => [ :active_avatar, :touch ]

  def_delegators :profile_resource,
      :handle, :handle=,
      :first_name, :first_name=,
      :last_name, :last_name=,
      :gender, :gender=
  
  before_create do |profile|
    if profile.resource.nil?
      profile.resource = UserInfo.new(:user_id => profile.user_id)
    end
  end
  
  after_create do |profile|
    profile.publish!
  end
  
  alias :user_info :resource
  alias :profile_info :resource

  def profile_resource
    self.resource ||= UserInfo.new    
  end
  
  def active_avatar(avatar)
    if avatar.active?
      # Following update didn't work. Used update_all instead.
      # Posting::Avatar.update((self.avatar_ids - [ avatar.id ]), :active => false)
      Posting::Avatar.update_all([ 'active = ?', false], [ 'id in (?)', (self.avatar_ids - [ avatar.id ]) ])
    end
    true
  end
  
  def avatar
    avatars.where('active = ?', true).limit(1).first
  end
  
  def avatar?
    avatar.present?
  end
    
  def avatar_id
    avatar.id if avatar.present?
  end

  def photos
    self.postings.only(Posting::Photo)
  end
  
  def touch(avatar=nil)
    super()
  end

end
