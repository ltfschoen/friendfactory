require 'tag_scrubber'

class Wave::Profile < Wave::Base

  include TagScrubber

  RepublishWindow = 6.hours

  delegate \
      :email,
      :emailable?,
      :admin,
      :admin?,
    :to => :user

  delegate \
      :handle,
      :age,
      :dob,
      :location,
      :first_name,
      :last_name,
      :avatar,
      :avatar?,
    :to => :persona

  alias :subject :handle

  belongs_to :persona,
      :class_name  => 'Persona::Base',
      :foreign_key => 'resource_id'

  alias_attribute :persona_id, :resource_id

  before_save :update_persona

  def update_persona
    if user_id_changed?
      self.persona_id = user.person.id
    end
  end

  private :update_persona

  has_many :friendships, :class_name => 'Friendship::Base'

  has_many :friends,
      :through    => :friendships,
      :class_name => 'Wave::Profile' do
    def type(type)
      where(:friendships => { :type => type })
    end
  end

  has_many :inverse_friendships,
      :class_name  => 'Friendship::Base',
      :foreign_key => '`friend_id`'

  has_many :inverse_friends,
      :through => :inverse_friendships,
      :source  => :profile do
    def type(type)
      where(:friendships => { :type => type })
    end
  end

  # TODO Implement
  # def admirers(site)
  #   inverse_friends.map{ |user| user.profile(site) }
  # end

  def tag_list
    current_site.present? ? tag_list_on(current_site) : []
  end

  def photos
    postings.type(Posting::Photo).published.order('created_at desc').limit(9)
  end

  # TODO Implement
  def set_tag_list_on(site)
    # if resource.present?
    #   signal_ids = site.signal_categories.map { |category| resource.send(:"#{category.name}_id") }.compact
    #   signal_display_names = Signal::Base.find_all_by_id(signal_ids).map(&:display_name)
    #   tag_list = [ signal_display_names, scrub_tag(resource.location) ].flatten.compact.join(',')
    #   super(site, tag_list)
    # end
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

  def touch(avatar = nil)
    super()
  end

  def publish_posting_to_waves(posting)
    # TODO: Only publish a flag, not the avatar itself
    if site = posting.site
      related_postings(posting).map(&:unpublish!)
      site.home_wave
    end
  end

  def related_postings(posting)
    posting.site.home_wave.postings.
        type(Posting::Avatar).
        published.
        where(:created_at => (Time.now - RepublishWindow)...Time.now).
        where(:user_id => posting.user[:id]).
        where('`postings`.`id` <> ?', posting.id)
  end

end
