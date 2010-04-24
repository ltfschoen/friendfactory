class Wave::Profile < Wave::Base
  
  has_many :avatars,
      :class_name  => 'Posting::Avatar',
      :foreign_key => 'wave_id' do
    def active
      find :first, :conditions => [ 'active = true' ]
    end
  end
  
  def before_update
    active_avatar = self.avatar
    if active_avatar && @built_avatar && @built_avatar != active_avatar
      active_avatar.update_attribute(:active, false)
    end
  end
  
  def avatar
    self.avatars.active
  end
  
  def build_avatar(avatar_attrs)
    @built_avatar = self.avatars.build(avatar_attrs.merge(:active => true))
  end
      
end
