class Publication < ActiveRecord::Base

  belongs_to :wave,
      :class_name    => 'Wave::Base',
      :foreign_key   => 'wave_id',
      :counter_cache => :publications_count

  belongs_to :posting,
      :class_name  => 'Posting::Base',
      :foreign_key => 'posting_id'

  has_one :user,
      :through => :posting

end
