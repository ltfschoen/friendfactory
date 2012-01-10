class Wave::Base < ActiveRecord::Base

  include ActiveRecord::Transitions
  
  set_table_name :waves

  @@ignore_after_add_posting_callback = false

  alias_attribute :subject, :topic
  alias_attribute :body, :description
  
  def technical_description
    self.class.name.demodulize
  end

  delegate \
      :email,
      :emailable?,
      :admin,
      :admin?,
      :handle,
      :avatar,
      :avatar?,
    :to => :user

  state_machine do
    state :published
    state :unpublished

    event :publish do
      transitions :to => :published, :from => [ :unpublished, :published ]
    end

    event :unpublish do
      transitions :to => :unpublished, :from => [ :unpublished, :published ]
    end
  end

  scope :site, lambda { |site|
    joins('INNER JOIN `sites_waves` on `waves`.`id` = `sites_waves`.`wave_id`').
    where('`sites_waves`.`site_id` = ?', site.id)
  }

  scope :type, lambda { |*types| where('`waves`.`type` in (?)', types.map(&:to_s)) }  
  scope :user, lambda { |user| where(:user_id => user.id) }
  scope :published, where(:state => :published)

  acts_as_taggable

  belongs_to :user,
      :class_name => 'Personage',
      :include    => :persona

  has_and_belongs_to_many :sites,
      :class_name              => 'Site',
      :join_table              => 'sites_waves',
      :foreign_key             => 'wave_id',
      :association_foreign_key => 'site_id'

  has_many :publications, :foreign_key => 'wave_id'

  has_many :postings,
      :through       => :publications,
      :source        => :resource,
      :source_type   => 'Posting::Base',
      :conditions    => 'parent_id is null',
      :after_add     => :after_add_posting do
    def exclude(*types)
      where('type not in (?)', types.map(&:to_s))
    end
  end

  has_many :bookmarks, :foreign_key => 'wave_id'
  
  belongs_to :resource, :polymorphic => true

  # before_save do |wave|
  #   empty_tag_list = nil
  #   wave.sites.each do |site|
  #     # Override set_tag_list_on in inherited classes and call super.
  #     wave.set_tag_list_on(site, empty_tag_list)
  #   end
  # end

  def set_tag_list_on!(site)
    set_tag_list_on(site)
    save!
  end

  def permitted?(user_or_user_id)
    return true if permitted_user_ids == :all
    if user_or_user_id
      user_id = user_or_user_id.is_a?(User) ? user_or_user_id.id : user_or_user_id
      ids = *permitted_user_ids
      ids.include?(user_id)
    else
      false
    end
  end

  private

  def permitted_user_ids
    :all
  end

  def transaction
    ActiveRecord::Base.transaction { yield }
  rescue ActiveRecord::RecordInvalid
    false
  end

  def after_add_posting(posting)
    return unless posting
    increment!(:postings_count) if posting.published?
    unless @@ignore_after_add_posting_callback
      @@ignore_after_add_posting_callback = true
      transaction do
        waves = *publish_posting_to_waves(posting)
        waves.compact.uniq.each { |wave| wave.postings << posting }
      end
      @@ignore_after_add_posting_callback = false
    end
  end

  def publish_posting_to_waves(posting)
    # Override in inherited classes
  end

  def publish_posting_to_profile_wave(posting)
    if posting && profile = posting.user.profile
      profile
    end
  end

  def publish_posting_to_home_wave(posting)
    if posting && site = posting.site
      site.home_wave
    end
  end

end