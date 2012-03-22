require 'digest/sha1'

class Posting::Base < ActiveRecord::Base

  include ActiveRecord::Transitions

  set_table_name :postings

  # TODO: attr_readonly :user_id

  attr_accessor :site

  state_machine do
    state :unpublished
    state :published, :exit => :decrement_postings_counter

    event :publish do
      transitions :to => :published, :from => [ :unpublished, :publish ], :on_transition => :increment_postings_counter
    end

    event :unpublish do
      transitions :to => :unpublished, :from => [ :published, :unpublished ]
    end
  end

  scope :user, lambda { |user|
    where(:user_id => user[:id])
  }

  scope :site, lambda { |site|
    joins(:waves => :sites).
    where(:waves => { :sites => { :id => site[:id] }})
  }

  scope :type, lambda { |*types|
    where(:type => types.map(&:to_s))
  }

  scope :exclude, lambda { |*types|
    where('`postings`.`type` NOT IN (?)', types.map(&:to_s))
  }

  scope :published, where(:state => [ :published, :offered ])
  scope :unpublished, where(:state => :unpublished)

  scope :since, lambda { |date| where('`postings`.`created_at` > ?', date) }
  scope :order_by_updated_at_desc, order('`postings`.`updated_at` DESC')

  belongs_to :user, :class_name => 'Personage'

  acts_as_tree

  def comments
    children.type(Posting::Comment).scoped
  end

  has_many :publications,
      :foreign_key => 'posting_id'

  has_many :waves,
      :through => :publications,
      :order   => '`updated_at` DESC'

  ###

  def attributes=(attrs)
    sanitize_for_mass_assignment(attrs).each do |k, v|
      send("#{k}=", v)
    end
  end

  def sticky_until=(sticky_until = nil)
    if sticky_until.present?
      write_attribute(:sticky_until, (Time.zone.parse(sticky_until).utc.end_of_day rescue nil))
    end
  end

  def published?
    [ :published, :offered ].include?(current_state)
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

  def authorizes?(user, action)
    (action == 'show') || user.admin? || (user[:id] == self[:user_id])
  end

  private

  def increment_postings_counter
    waves.map{ |wave| wave.increment!(:postings_count) }
  end

  def decrement_postings_counter
    waves.map{ |wave| wave.decrement!(:postings_count) }
  end

  def set_hash_key
    self[:hash_key] = Digest::SHA1.hexdigest("#{id}#{created_at.to_i}")[0..7]
  end

end
