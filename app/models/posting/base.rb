require 'subscribable'

class Posting::Base < ActiveRecord::Base

  include ActiveRecord::Transitions
  include Subscribable

  set_table_name :postings

  delegate \
      :site,
      :email,
      :emailable?,
      :admin,
      :admin?,
      :handle,
      :avatar,
      :avatar?,
    :to => :user

  before_create :initialize_primed_at

  ###

  state_machine do
    state :unpublished
    state :published, :exit => :decrement_counts!

    event :publish do
      transitions :to => :published, :from => [ :unpublished, :publish ] , :on_transition => :increment_counts!
    end

    event :unpublish do
      transitions :to => :unpublished, :from => [ :published, :unpublished ]
    end
  end

  private

  def increment_counts!
    parent && parent.increment_children_count!(self)
    waves.map { |wave| wave.increment!(:postings_count) }
  end

  def decrement_counts!
    parent && parent.decrement_children_count!(self)
    waves.map { |wave| wave.decrement!(:postings_count) }
  end

  public

  ###

  scope :published, where(:state => :published)

  scope :unpublished, where(:state => :unpublished)

  scope :roots, where(:parent_id => nil)

  scope :user, lambda { |user|
      where(:user_id => user[:id])
  }

  scope :type, lambda { |*types|
      where(:type => types.map(&:to_s))
  }

  scope :exclude, lambda { |*types|
      where('"postings"."type" NOT IN (?)', types.map(&:to_s))
  }

  scope :since, lambda { |date|
      where('"postings"."created_at" > ?', date)
  }

  scope :site, lambda { |site|
      joins(:user => :user).where(:users => { :site_id => site[:id] })
  }

  belongs_to :user,
      :class_name => 'Personage',
      :include    => :persona

  belongs_to :resource, :polymorphic => true

  ###

  has_many :publishables,
      :class_name  => 'Publication',
      :foreign_key => 'posting_id'

  has_many :waves,
      :through => :publishables

  ###

  belongs_to :parent,
      :class_name   => 'Posting::Base',
      :foreign_key  => 'parent_id'

  has_many :children,
      :class_name   => 'Posting::Base',
      :foreign_key  => 'parent_id',
      :dependent    => :destroy

  has_many :comments,
      :class_name   => 'Posting::Comment',
      :foreign_key  => 'parent_id',
      :dependent    => :destroy,
      :conditions   => 'length("postings"."body") > 0',
      :after_add    => :after_add_to_comments,
      :after_remove => :after_remove_from_comments,
      :counter_sql  => proc {
          %Q(SELECT COUNT(*) FROM
            ((SELECT DISTINCT p2.lev2 AS id FROM
                (SELECT p1.id AS lev1, p2.id AS lev2
                FROM postings AS p1
                LEFT JOIN postings AS p2 ON p2.parent_id = p1.id
                WHERE p1."id" = #{id}
                AND p2."state" = 'published'
                AND p2."type" = 'Posting::Comment'
                AND (length(p2."body") > 0)) AS p2
             WHERE lev2 IS NOT NULL)
            UNION
            (SELECT DISTINCT p3.lev3 FROM
                (SELECT p1.id AS lev1, p2.id AS lev2, p3.id AS lev3
                FROM postings AS p1
                LEFT JOIN postings AS p2 ON p2.parent_id = p1.id
                LEFT JOIN postings AS p3 ON p3.parent_id = p2.id
                WHERE p1."id" = #{id}
                AND p3."state" = 'published'
                AND p3."type" = 'Posting::Comment'
                AND (length(p3."body" > 0))) as p3
             WHERE lev3 IS NOT NULL)) t1) }

  def after_add_to_comments(posting)
    increment_comments_count!(posting)
    posting.root.subscriptions.create(posting.user)
  end

  def increment_comments_count!(posting)
    if posting.published?
      posting.root.increment!(:comments_count)
    end
  end

  def decrement_comments_count!(posting)
    root.decrement!(:comments_count)
  end

  alias_method :after_remove_from_comments, :decrement_comments_count!

  def ancestors
    node, nodes = self, []
    nodes << node = node.parent while node.parent
    nodes
  end

  def root
    node = self
    node = node.parent while node.parent
    node
  end

  def siblings
    self_and_siblings - [self]
  end

  def self_and_siblings
    parent ? parent.children : self.class.roots
  end

  ###

  def fetchables(limit = nil)
    comments.published.
        includes(:user => :profile, :user => { :persona => :avatar }).
        order('"created_at" DESC').
        limit(limit).
        sort_by { |comment| comment.created_at }
  end

  def fetch_type
    :posting_base
  end

  ###

  def attributes=(attrs)
    sanitize_for_mass_assignment(attrs).each do |k, v|
      send("#{k}=", v)
    end
  end

  def authorizes?(user, action)
    (action == 'show') || user.admin? || (user[:id] == self[:user_id])
  end

  def sticky_until=(sticky_until = nil)
    if sticky_until.present?
      write_attribute(:sticky_until, (Time.zone.parse(sticky_until).utc.end_of_day rescue nil))
    end
  end

  def to_s
    self[:type].to_s + ':' + self[:id].to_s
  end

  def existing_record?
    !new_record?
  end

  private

  def set_hash_key
    self[:hash_key] = Digest::SHA1.hexdigest("#{id}#{created_at.to_i}")[0..7]
  end

  def initialize_primed_at
    self[:primed_at] = Time.now.utc.to_s(:db)
  end

end
