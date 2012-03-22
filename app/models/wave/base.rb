class Wave::Base < ActiveRecord::Base

  include ActiveRecord::Transitions

  set_table_name :waves

  @@ignore_after_add_posting_callback = false

  alias_attribute :subject, :topic
  alias_attribute :body, :description

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
    state :disabled

    event :publish do
      transitions :to => :published, :from => [ :unpublished, :published, :disabled ]
    end

    event :unpublish do
      transitions :to => :unpublished, :from => [ :unpublished, :published ]
    end

    event :disable do
      transitions :to => :disabled, :from => [ :published ]
    end
  end

  scope :site, lambda { |site|
    joins('INNER JOIN `sites_waves` on `waves`.`id` = `sites_waves`.`wave_id`').
    where('`sites_waves`.`site_id` = ?', site.id)
  }

  scope :type, lambda { |*types| where('`waves`.`type` in (?)', types.map(&:to_s)) }

  scope :user, lambda { |user| where(:user_id => user.id) }

  scope :published, where(:state => :published)

  scope :unpublished, where(:state => :unpublished)

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
      :conditions    => { :parent_id => nil },
      :after_add     => :after_add_posting do
    def exclude(*types)
      where('`type` NOT IN (?)', types.map(&:to_s))
    end

    def natural_order
      order('`postings`.`sticky_until` DESC, `postings`.`primed_at` DESC')
    end
    # def <<(posting)
    #   raise 'here!'
    #   # raise proxy_reflection.methods.sort.inspect
    #   proxy_target << posting
    #   proxy_owner
    # # rescue
    # #   puts "here!"
    # end
  end

  has_many :bookmarks, :foreign_key => 'wave_id'

  belongs_to :resource, :polymorphic => true

  def readable?(user_id)
    false
  end

  def writable?(user_id)
    false
  end

  ###

  private

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
        if waves.present?
          waves.delete(self)
          waves.compact.uniq.each { |wave| wave.postings << posting }
        end
      end
      @@ignore_after_add_posting_callback = false
    end
  end

  # Override in inherited classes
  def publish_posting_to_waves(posting)
    []
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

  def owner?(user_id)
    user_id == self[:user_id]
  end

end