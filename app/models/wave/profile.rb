require 'tag_scrubber'

class Wave::Profile < Wave::Base

  include TagScrubber
  
  has_and_belongs_to_many :avatars,
      :class_name              => 'Posting::Avatar',
      :foreign_key             => 'wave_id',
      :association_foreign_key => 'posting_id',
      :join_table              => 'postings_waves',
      :order                   => 'updated_at desc',
      :after_add               => [ :active_avatar, :touch ]

  delegate :handle, :handle=, :first_name, :gender, :age, :to => :resource
  
  acts_as_taggable  
  attr_accessor :current_site
  validates_presence_of :current_site, :message => 'required for tagging'

  validates_presence_of :handle, :unless => :first_name

  before_validation do |profile|
    profile.resource.present?
  end
    
  before_save do |profile|
    tag_list = [
      profile.resource.gender_description,
      profile.resource.orientation_description,
      profile.resource.deafness_description,
      scrub_tag(profile.resource.location_description)
    ].compact * ','
    profile.set_tag_list_on(profile.current_site, tag_list)
  end
  
  after_create do |profile|
    profile.publish!
  end
  
  alias :user_info :resource

  def resource
    super || self.resource = UserInfo.new.tap { |user_info| user_info.user = user }
  end
  
  def tag_list
    current_site.present? ? tag_list_on(current_site) : []  
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
