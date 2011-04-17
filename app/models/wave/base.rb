class Wave::Base < ActiveRecord::Base

  include ActiveRecord::Transitions
  
  set_table_name :waves

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

  scope :type, lambda { |*types| where('type in (?)', types.map(&:to_s)) }
  scope :user, lambda { |user| where(:user_id => user.id) }
  scope :site, lambda { |site| joins(:sites).where(:sites => { :id => site.id })}
  scope :published, where(:state => :published)

  acts_as_taggable

  belongs_to :user

  has_and_belongs_to_many :sites,
      :class_name              => 'Site',
      :join_table              => 'sites_waves',
      :foreign_key             => 'wave_id',
      :association_foreign_key => 'site_id'

  has_and_belongs_to_many :postings,
      :class_name              => 'Posting::Base',
      :join_table              => 'postings_waves',
      :foreign_key             => 'wave_id',
      :association_foreign_key => 'posting_id',
      :conditions              => 'parent_id is null',
      :before_add              => :before_add_posting_to_wave,
      :after_add               => :after_add_posting_to_wave do
    
    def exclude(*types)
      where('type not in (?)', types.map(&:to_s))
    end    
    
    def <<(wave_or_posting)
      if wave_or_posting.is_a?(Wave::Base)
        wave_or_posting = Posting::WaveProxy.new.tap do |proxy|
          proxy.user = wave_or_posting.user
          proxy.resource = wave_or_posting
          proxy.state = :published
        end
      end
      super(wave_or_posting)
    end
  end
  
  belongs_to :resource, :polymorphic => true

  before_save do |wave|
    wave.sites.each do |site|
      wave.set_tag_list_on(site, nil)
    end
  end

  def self.default
    Wave::Base.first
  end

  def before_add_posting_to_wave(posting)
    # Override in inherited wave classes.
  end

  def after_add_posting_to_wave(posting)
    # Override in inherited classes then call super.
    distribute_posting(posting)
  end

  def distribute_posting(posting)
    unless posting.ignore_distribute_callback
      posting.ignore_distribute_callback = true
      posting.distribute(sites)
    end
  end

end
