class Invitation < ActiveRecord::Base
  
  has_many :events,
      :class_name  => 'Wave::Event',
      :foreign_key => 'event_id'
  
  has_many :profiles,
      :class_name  => 'Wave::Profile',
      :foriegn_key => 'profile_id'

end
