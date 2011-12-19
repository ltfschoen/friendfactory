class Wave::Base < ActiveRecord::Base

  include ActiveRecord::Transitions
  
  set_table_name :waves

  @@ignore_after_add_posting_callback = false

  alias_attribute :subject, :topic
  alias_attribute :body, :description

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

  scope :site, lambda { |site| joins('INNER JOIN `sites_waves` on `waves`.`id` = `sites_waves`.`wave_id`').where('`sites_waves`.`site_id` = ?', site.id) }
  scope :type, lambda { |*types| where('`waves`.`type` in (?)', types.map(&:to_s)) }
  scope :user, lambda { |user| where(:user_id => user.id) }
  scope :published, where(:state => :published)

  acts_as_taggable

  belongs_to :user

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

  def technical_description
    self.class.name
  end

  private

  def after_add_posting(posting)
    increment!(:postings_count) if posting.published?
    unless @@ignore_after_add_posting_callback
      @@ignore_after_add_posting_callback = true
      add_posting_to_other_waves(posting)
      @@ignore_after_add_posting_callback = false
    end
  end

  def add_posting_to_other_waves(posting)
    # Override in inherited classes
  end

  def add_posting_to_personal_wave(posting)
    if posting.present? && profile = posting.user.profile
      profile.postings << posting
    end
  end

  def add_posting_to_home_wave(posting)
    if posting.present? && posting.site.present?
      if wave = posting.site.home_wave
        wave.postings << posting
      end
    end
  end

end