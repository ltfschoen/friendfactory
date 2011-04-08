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

  scope :published, where(:state => :published)

  acts_as_taggable

  belongs_to :user
  has_and_belongs_to_many :sites,
      :class_name              => 'Site',
      :join_table              => 'sites_waves',
      :foreign_key             => 'wave_id',
      :association_foreign_key => 'site_id',
      :after_add               => :set_tag_list_for_site

  has_and_belongs_to_many :postings,
      :class_name              => 'Posting::Base',
      :join_table              => 'postings_waves',
      :foreign_key             => 'wave_id',
      :association_foreign_key => 'posting_id',
      :conditions              => 'parent_id is null',
      :after_add               => :distribute_posting do
    def only(*types)
      where('type in (?)', types.map(&:to_s))
    end    
    def type(*types)
      where('type in (?)', types.map(&:to_s))
    end    
    def exclude(*types)
      where('type not in (?)', types.map(&:to_s))
    end    
    def published
      where(:state => :published)
    end    
  end
  
  belongs_to :resource, :polymorphic => true

  def self.default
    Wave::Base.first
  end

  def set_tag_list_for_site(site)
    # Override in inherited classes.
  end

  def distribute_posting(posting)
    unless posting.ignore_distribute_callback
      posting.ignore_distribute_callback = true
      posting.distribute(sites)
    end
  end

end
