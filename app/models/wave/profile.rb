class Wave::Profile < Wave::Base
  
  has_and_belongs_to_many :avatars,
      :class_name              => 'Posting::Avatar',
      :foreign_key             => 'wave_id',
      :association_foreign_key => 'posting_id',
      :join_table              => 'postings_waves',
      :order                   => 'created_at desc' do
    def active
      find :first, :conditions => [ 'active = true' ]
    end
  end

  has_and_belongs_to_many :photos,
      :class_name              => 'Posting::Photo',
      :foreign_key             => 'wave_id',
      :association_foreign_key => 'posting_id',
      :join_table              => 'postings_waves',
      :order                   => 'created_at desc'

  def before_update
    active_avatar = self.avatar
    if active_avatar && @built_avatar && @built_avatar != active_avatar
      active_avatar.update_attribute(:active, false)
    end
  end
  
  def avatar
    self.avatars.active
  end
end
