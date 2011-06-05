require 'tag_scrubber'

class Wave::Profile < Wave::Base

  include TagScrubber
  
  delegate :handle, :handle=, :first_name, :first_name=, :last_name, :last_name=, :gender, :age, :to => :resource
  
  validates_presence_of :handle, :unless => :first_name

  before_validation do |profile|
    profile.resource.present?
  end
      
  after_create do |profile|
    profile.publish!
  end
  
  alias :user_info :resource

  def after_add_posting_to_wave(posting)
    set_active_avatar(posting)
    touch(posting)
    super
  end
  
  # Use an association to provide eager loading.
  has_many :avatars,
      :through      => :publications,
      :source       => :resource,
      :source_type  => 'Posting::Base',
      :conditions => { :type => Posting::Avatar, :parent_id => nil }
  
  # Use an association to provide eager loading.
  # Can't use has_one :active_avatar becauses condition clause
  # isn't respected and all associated postings (not just avatars)
  # are eagerly loaded and a completely wrong posting will be returned.
  has_many :active_avatars,
      :through      => :publications,
      :source       => :resource,
      :source_type  => 'Posting::Base',
      :conditions   => { 'postings.type' => Posting::Avatar, 'postings.parent_id' => nil, 'postings.state' => :published, 'postings.active' => true },
      :order        => 'created_at desc'

  def active_avatar
    active_avatars.sort_by{ |avatar| avatar.created_at }.last
  end
  
  alias :avatar :active_avatar
  
  def avatar?
    avatar.present?
  end
        
  def avatar_id
    avatar.try(:id)
  end

  def resource
    super || self.resource = UserInfo.new.tap { |user_info| user_info.user = user }
  end
  
  def tag_list
    current_site.present? ? tag_list_on(current_site) : []  
  end

  def photos
    postings.type(Posting::Photo).published.order('created_at desc').limit(9)
  end
    
  def set_tag_list_on(site, tag_list)
    if resource.present?
      tag_list = [
          tag_list,
          resource.gender_description,
          resource.orientation_description,
          custom_signal_description_for_site(site),
          scrub_tag(resource.location_description)
      ].compact * ','
      super(site, tag_list)
    end
  end

  private
  
  def set_active_avatar(avatar)
    if avatar.active?
      avatar_ids = avatars.map(&:id)
      Posting::Avatar.update_all([ 'active = ?', false], [ 'id in (?)', (avatar_ids - [ avatar.id ]) ])
    end
  end

  def custom_signal_description_for_site(site)
    case site.name
    when 'friskyhands' then resource.deafness_description
    when 'positivelyfrisky' then resource.hiv_status_description
    end
  end

  def touch(avatar = nil)
    super()
  end

end
