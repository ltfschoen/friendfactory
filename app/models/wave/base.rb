class Wave::Base < ::Posting::Base

  @@ignore_after_add_posting_callback = false

  alias_attribute :topic,       :subject
  alias_attribute :description, :body

  scope :site, lambda { |site|
      joins(:sites).where(:sites => { :id => site[:id] })
  }

  has_and_belongs_to_many :sites,
      :class_name              => 'Site',
      :join_table              => 'sites_waves',
      :foreign_key             => 'wave_id',
      :association_foreign_key => 'site_id'

  has_many :publications,
      :foreign_key   => 'wave_id',
      :before_add    => :increment_publications_count!,
      :before_remove => :decrement_publications_count!

  def increment_publications_count!(publication)
    posting = publication.posting
    if posting && posting.published?
      increment!(:publications_count)
    end
  end

  def decrement_publications_count!(publication)
    decrement!(:publications_count)
  end

  has_many :postings,
      :through    => :publications,
      :conditions => { :parent_id => nil },
      :after_add  => :after_add_posting do
    def natural_order
      order('`postings`.`sticky_until` DESC, `postings`.`primed_at` DESC')
    end
  end

  def rollcall
    Personage.select('distinct `personages`.*').
        enabled.
        joins(:postings => :publishables).
        merge(Posting::Base.published).
        where(:publications => { :wave_id => self[:id] }).
        scoped
  end

  has_many :bookmarks, :foreign_key => 'wave_id'

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
    return if posting.nil? || posting.user.nil?
    posting.user.profile
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