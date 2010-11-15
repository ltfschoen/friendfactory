class Wave::Profile < Wave::Base
  
  has_and_belongs_to_many :avatars,
      :class_name              => 'Posting::Avatar',
      :foreign_key             => 'wave_id',
      :association_foreign_key => 'posting_id',
      :join_table              => 'postings_waves',
      :order                   => 'created_at desc' do
    def active
      find :all, :conditions => [ 'active = ?', true ]
    end    
  end
  
  def self.avatars    
    scoped.order('created_at desc').all.map(&:avatar)
  end
  
  def avatar
    avatars.active.first
  end
  
  def avatar=(avatar)
    if avatar.present? && avatar_ids.include?(avatar.id)
      avatars.active.each do |posting|
        posting.update_attribute(:active, false)
      end
      return avatar.update_attribute(:active, true)
    end
    false
  end
  
  def avatar_id
    avatar.id if avatar.present?
  end

  def photos
    self.postings.only(Posting::Photo)
  end
end
