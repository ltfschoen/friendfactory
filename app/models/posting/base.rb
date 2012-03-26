class Posting::Base < ActiveRecord::Base

  include ActiveRecord::Transitions

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
    state :published # , :exit => :decrement_postings_counter

    event :publish do
      transitions :to => :published, :from => [ :unpublished, :publish ] # , :on_transition => :increment_postings_counter
    end

    event :unpublish do
      transitions :to => :unpublished, :from => [ :published, :unpublished ]
    end
  end

  scope :published,
      where(:state => [ :published, :offered ])

  scope :unpublished,
      where(:state => :unpublished)

  def published?
    [ :published, :offered ].include?(current_state)
  end

  ###

  scope :roots,
      where(:parent_id => nil)

  scope :user, lambda { |user|
      where(:user_id => user[:id])
  }

  scope :type, lambda { |*types|
      where(:type => types.map(&:to_s))
  }

  scope :exclude, lambda { |*types|
      where('`postings`.`type` NOT IN (?)', types.map(&:to_s))
  }

  scope :since, lambda { |date|
      where('`postings`.`created_at` > ?', date)
  }

  belongs_to :user,
      :class_name => 'Personage',
      :include    => :persona

  belongs_to :resource, :polymorphic => true

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
