require 'tag_scrubber'

class Wave::Profile < Wave::Base

  include TagScrubber
  
  delegate :handle, :handle=, :first_name, :gender, :age, :to => :resource
  
  validates_presence_of :handle, :unless => :first_name

  before_validation do |profile|
    profile.resource.present?
  end
      
  after_create do |profile|
    profile.publish!
  end
  
  alias :user_info :resource

  def after_add_posting_to_wave(posting)
    active_avatar(posting)
    touch(posting)
    super
  end
  
  def avatars
    postings.type(Posting::Avatar)
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

  def resource
    super || self.resource = UserInfo.new.tap { |user_info| user_info.user = user }
  end
  
  def tag_list
    current_site.present? ? tag_list_on(current_site) : []  
  end

  def photos
    self.postings.only(Posting::Photo)
  end
  
  def set_tag_list_for_site(site)
    set_tag_list && save
  end

  def set_tag_list
    if resource.present?
      tag_list = [
          resource.gender_description,
          resource.orientation_description,
          resource.deafness_description,
          scrub_tag(resource.location_description)
      ].compact * ','
      sites.each { |site| set_tag_list_on(site, tag_list) }
    end
  end

  private
  
  def active_avatar(avatar)
    if avatar.active?
      avatar_ids = avatars.map(&:id)
      Posting::Avatar.update_all([ 'active = ?', false], [ 'id in (?)', (avatar_ids - [ avatar.id ]) ])
    end
  end

  def touch(avatar=nil)
    super()
  end

end
