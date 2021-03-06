class Wave::Base < ::Posting::Base

  alias_attribute :topic,       :subject
  alias_attribute :description, :body

  scope :site, lambda { |site|
      joins(:sites).where(:sites => { :id => site[:id] }).readonly(false)
  }

  has_and_belongs_to_many :sites,
      :class_name              => 'Site',
      :join_table              => 'sites_waves',
      :foreign_key             => 'wave_id',
      :association_foreign_key => 'site_id'

  ###

  has_many :publications, :foreign_key => 'wave_id'

  has_many :postings,
      :through    => :publications,
      :conditions => { :parent_id => nil } do
    def <<(posting)
      proxy_owner = proxy_association.owner
      proxy_owner.class.transaction do
        parent = proxy_owner.publications.create!(:posting => posting)
        secondary_waves = *proxy_owner.publish_posting_to_waves(posting)
        if secondary_waves.present?
          secondary_waves.delete(proxy_owner)
          secondary_waves.compact.uniq.each do |wave|
            posting.publishables.create!(:wave => wave, :parent => parent)
          end
        end
        posting
      end
    end
    def natural_order
      order('"postings"."sticky_until" DESC, "postings"."primed_at" DESC')
    end
    def authors_order
      select(%{distinct "postings"."user_id", max("postings"."created_at") as created_at}).
      group(%{"postings"."user_id"}).
      merge(Posting::Base.published).
      order("created_at DESC")
    end
  end

  has_many :personages, through: :postings, source: :user, uniq: true

  def publish_posting_to_waves(posting)
    [] # Override in descendant classes
  end

  def publish_posting_to_profile_wave(posting)
    if posting && posting.user
      posting.user.profile
    end
  end

  def publish_posting_to_home_wave(posting)
    @home_wave ||= begin
      if posting && site = posting.site
        site.home_wave
      end
    end
  end

  ###

  has_many :bookmarks, :foreign_key => 'wave_id'

  def rollcall
    @rollcall ||= personages.scoped
  end

  def writable?(user_id)
    false
  end

  ###

  private

  def owner?(user_id)
    user_id == self[:user_id]
  end

end
