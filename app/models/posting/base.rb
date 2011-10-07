class Posting::Base < ActiveRecord::Base

  include ActiveRecord::Transitions
  
  set_table_name :postings

  # TODO: attr_readonly :user_id

  attr_accessor :ignore_distribute_callback

  acts_as_tree :order => 'created_at asc'
  
  state_machine do
    state :unpublished
    state :published
    
    event :publish do
      transitions :to => :published, :from => [ :unpublished, :published ]
    end
    
    event :unpublish do
      transitions :to => :unpublished, :from => [ :unpublished, :published ]
    end
  end
  
  scope :type, lambda { |*types| where('`postings`.`type` IN (?)', types.map(&:to_s)) }
  scope :user, lambda { |user| where(:user_id => user.id) }
  scope :published, where(:state => :published)
  scope :unpublished, where(:state => :unpublished)
  scope :since, lambda { |date| where('`postings`.`created_at` > ?', date) }
  scope :exclude, lambda { |*types| where('`postings`.`type` NOT IN (?)', types.map(&:to_s)) }
  
  has_many :children, :class_name  => 'Posting::Base', :foreign_key => 'parent_id'

  belongs_to :user
  # belongs_to :resource, :polymorphic => true  
  
  has_many :publications, :as => :resource
  has_many :waves, :through => :publications, :order => 'updated_at desc'

  def self.publish_to(destination, &block)
    after_create Publisher.new(destination, &block)
  end

  def attributes=(attrs)
    sanitize_for_mass_assignment(attrs).each do |k, v|
      send("#{k}=", v)
    end
  end

  def sticky_until=(sticky_until = nil)
    if sticky_until.present?
      write_attribute(:sticky_until, (Time.zone.parse(sticky_until).utc.tomorrow - 1.second rescue nil))
    end
  end

  def distribute(sites)
    # Override in inherited classes. Make sure
    # to call super after finishing distribution.
    self.ignore_distribute_callback = false
  end
  
  # Thinking-Sphinx
  # define_index do
  #   indexes body
  #   # TODO: Reestablish indexes on associated waves
  #   # indexes wave.topic,       :as => :wave_topic
  #   # indexes wave.description, :as => :wave_description
  #   indexes [ user.first_name, user.last_name], :as => :full_name
  #   indexes user.handle
  #   indexes user_id
  #   has :created_at
  #   has :updated_at
  #   has [ :user_id, :receiver_id ], :as => :recipient_ids
  #   has :private, :type => :boolean
  # end
    
  def to_s
    self[:type].to_s + ':' + self[:id].to_s
  end
  
  def existing_record?
    !new_record?
  end
  
end
