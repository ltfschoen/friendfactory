class Publication < ActiveRecord::Base

  delegate \
      :published?,
      :unpublished?,
    :to => :posting

  scope :published, lambda {
    joins(:posting).merge(Posting::Base.published)
  }

  scope :unpublished, lambda {
    joins(:posting).merge(Posting::Base.unpublished)
  }

  belongs_to :wave,
      :class_name  => 'Wave::Base',
      :foreign_key => 'wave_id'

  belongs_to :posting,
      :class_name  => 'Posting::Base',
      :foreign_key => 'posting_id'

  belongs_to :parent,
      :class_name  => 'Publication',
      :foreign_key => 'parent_id'

  has_many :children,
      :class_name  => 'Publication',
      :foreign_key => 'parent_id'

  has_one :user, :through => :posting

end
