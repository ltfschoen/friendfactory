require 'tag_scrubber'
require 'empty_avatar'

class Wave::Profile < Wave::Base

  include TagScrubber

  delegate :handle, :age, :location, :first_name, :last_name, :to => :person
  delegate :email, :admin, :admin?, :to => :user

  # Default Signals
  delegate :gender, :orientation, :relationship, :to => :person

  # Custom Signals
  delegate :deafness, :hiv_status, :board_type, :military_service, :to => :person
  
  # delegate :email, :emailable?, :admin, :admin?, :to => :user
  
  # before_validation :'resource.present?'
  # before_update     :'resource.save'  

  alias :user_info :resource

  belongs_to :person, :class_name => 'Person', :foreign_key => 'resource_id'
  alias_attribute :person_id, :resource_id

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
      :conditions   => { :postings => { :type => Posting::Avatar, :parent_id => nil, :active => true, :state => :published }},
      :order        => '`postings`.`created_at` desc'

  has_many :friendships, :class_name => 'Friendship::Base'
  has_many :friends, :through => :friendships, :class_name => 'Wave::Profile' do
    def type(type)
      where(:friendships => { :type => type })
    end
  end

  has_many :inverse_friendships, :class_name => 'Friendship::Base', :foreign_key => '`friend_id`'
  has_many :inverse_friends, :through => :inverse_friendships, :source => :profile do
    def type(type)
      where(:friendships => { :type => type })
    end
  end

  # def admirers(site)
  #   inverse_friends.map{ |user| user.profile(site) }
  # end

  # def active_avatar
  #   active_avatars.limit(1).first
  # end

  def avatar(reload = false)
    return @avatar if reload == false && defined?(@avatar)
    @avatar = active_avatars.limit(1).first || EmptyAvatar.new(self)
  end

  def avatar?
    @avatar.present? && !@avatar.silhouette?
  end

  def avatar_id
    @avatar.try(:id)
  end

  def set_active_avatar(avatar)
    if avatar.active?
      avatar_ids = avatars.map(&:id)
      Posting::Avatar.update_all([ 'active = ?', false], [ 'id in (?)', (avatar_ids - [ avatar.id ]) ])
    end
  end

  def tag_list
    current_site.present? ? tag_list_on(current_site) : []  
  end

  def photos
    postings.type(Posting::Photo).published.order('created_at desc').limit(9)
  end
    
  def set_tag_list_on(site)
    if resource.present?
      signal_ids = site.signal_categories.map { |category| resource.send(:"#{category.name}_id") }.compact
      signal_display_names = Signal::Base.find_all_by_id(signal_ids).map(&:display_name)          
      tag_list = [ signal_display_names, scrub_tag(resource.location) ].flatten.compact.join(',')
      super(site, tag_list)
    end
  end
  
  def toggle_poke(profile_id)
    return false if profile_id == self.id
    if poke = self.friendships.type(Friendship::Poke).find_by_friend_id(profile_id)
      poke.delete
      nil
    else
      poke = Friendship::Poke.new(:friend_id => profile_id)
      self.friendships << poke
      poke
    end
  end

  def has_friended?(profile_id, type)
    self.friendships.where(:friend_id => profile_id).type(type).limit(1).present?
  end

  def has_poked?(profile_id)
    self.has_friended?(profile_id, ::Friendship::Poke)
  end

  private

  def touch(avatar = nil)
    super()
  end
  
end
