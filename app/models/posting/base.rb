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

  scope :roots, where(:parent_id => nil)

  scope :published, where(:state => [ :published, :offered ])
  scope :unpublished, where(:state => :unpublished)

  scope :since, lambda { |date| where('`postings`.`created_at` > ?', date) }
  scope :order_by_updated_at_desc, order('`postings`.`updated_at` DESC')

  before_create :initialize_primed_at

  belongs_to :user, :class_name => 'Personage'

  ###

  acts_as_tree

  belongs_to :parent,
      :class_name   => 'Posting::Base',
      :foreign_key  => 'parent_id',
      :counter_cache => nil

  has_many :children,
      :class_name  => 'Posting::Base',
      :foreign_key => 'parent_id',
      :dependent   => :destroy,
      :counter_sql => proc {
          %Q(select count(*) from
            ((select distinct p2.lev2 as id from
                (select p1.id as lev1, p2.id as lev2
                from postings as p1
                left join postings as p2 on p2.parent_id = p1.id
                where p1.id = #{id}) as p2
             where lev2 is not null)
            union
            (select distinct p3.lev3 from
                (select p1.id as lev1, p2.id as lev2, p3.id as lev3
                from postings as p1
                left join postings as p2 on p2.parent_id = p1.id
                left join postings as p3 on p3.parent_id = p2.id
                where p1.id = #{id}) as p3
             where lev3 is not null)
            union
            (select distinct p4.lev4 from
                (select p1.id as lev1, p2.id as lev2, p3.id as lev3, p4.id as lev4
                from postings as p1
                left join postings as p2 on p2.parent_id = p1.id
                left join postings as p3 on p3.parent_id = p2.id
                left join postings as p4 on p4.parent_id = p3.id
                where p1.id = #{id}) as p4
             where lev4 is not null)) t1) },
      :after_add => :publish_child_to_parents_waves

  def comments
    children.type(Posting::Comment).scoped
  end

  private

  def publish_child_to_parents_waves(child)
    root.publications.each do |publication|
      child.publications << publication.clone
    end
  end

  ###

  public

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

  def initialize_primed_at
    self[:primed_at] = Time.now.utc.to_s(:db)
  end

end
