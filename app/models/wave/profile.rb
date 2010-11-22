class Wave::Profile < Wave::Base
  
  has_and_belongs_to_many :avatars,
      :class_name              => 'Posting::Avatar',
      :foreign_key             => 'wave_id',
      :association_foreign_key => 'posting_id',
      :join_table              => 'postings_waves',
      :order                   => 'created_at desc',
      :after_add               => :set_active_avatar
  
  alias :user_info :resource
  
  after_create do |profile|
    if profile.resource.nil?
      user_info = UserInfo.create(:user_id => profile.user_id)
      profile.resource = user_info
      profile.save
    end
    true
  end
  
  def set_active_avatar(avatar)
    if avatar.active?
      # Following update line didn't work. Used update_all instead.
      # Posting::Avatar.update((self.avatar_ids - [ avatar.id ]), :active => false)
      Posting::Avatar.update_all([ 'active = ?', false], [ 'id in (?)', (self.avatar_ids - [ avatar.id ]) ])
    end
    true
  end
  
  def avatar
    avatars.where('active = ?', true).limit(1).first
  end
    
  def avatar_id
    avatar.id if avatar.present?
  end

  def photos
    self.postings.only(Posting::Photo)
  end

end
