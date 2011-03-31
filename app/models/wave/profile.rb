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
      :gender, :gender=,
      :full_name
  
  acts_as_taggable
  attr_accessor :current_site
  validates_presence_of :current_site, :message => "required for tagging and can't be blank"

  before_validation do |profile|
    if profile.resource.nil?
      profile.resource = UserInfo.new(:user_id => profile.user_id)
    end
  end
    
  before_save do |profile|
    tag_list = [
      profile.resource.gender_description,
      profile.resource.orientation_description,
      profile.resource.deafness_description,
      scrub_tag(profile.resource.location_description)
    ].compact * ','
    profile.set_tag_list_on(profile.current_site.to_sym, tag_list)
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
  
  private
    
  def scrub_tag(dirty_tag)
    unless dirty_tag.blank?
      tag = reduce(unpunctuate(dirty_tag.strip))
      transpose(tag) || titleize(tag)
    end
  end
  
  def unpunctuate(tag)
    tag.gsub(/,|-|_/, ' ').gsub(/[^[:alnum:][:space:]]+/, '').gsub(/\s{2,}/, ' ').strip    
  end

  def reduce(tag)
    rejects = Admin::Tag.where(['taggable_type = ? and corrected is null', self.class.name]).order('defective asc').map(&:defective)
    tag.strip.gsub(/#{rejects * '|'}/i, '').strip
  end
  
  def transpose(tag)
    Admin::Tag.where(['taggable_type = ? and corrected is not null', self.class.name]).order('corrected asc, defective asc').each do |transpose|
      result = /#{transpose.defective}/i.match(tag)
      return transpose.corrected.strip if result.present?
    end
    nil
  end
  
  def titleize(tag)
    tag.titleize if tag.present?
  end  

end
