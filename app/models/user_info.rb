class UserInfo < ActiveRecord::Base
  set_table_name 'user_info'

  alias_attribute :hiv_status,          :deafness
  alias_attribute :board_type,          :deafness
  alias_attribute :military_service,    :deafness

  alias_attribute :gender_id,           :gender
  alias_attribute :orientation_id,      :orientation
  alias_attribute :relationship_id,     :relationship
  alias_attribute :deafness_id,         :deafness
  alias_attribute :hiv_status_id,       :deafness
  alias_attribute :board_type_id,       :deafness
  alias_attribute :military_service_id, :deafness
      
  belongs_to :user  

  has_one :profile, :as => :resource, :class_name => 'Wave::Profile'
    
  def handle
    self[:handle] || first_name
  end
  
  def first_name
    self[:first_name].try(:titleize)
  end
  
  def last_name
    self[:last_name].try(:titleize)
  end
  
  def full_name
    [ first_name, last_name ].compact * ' '
  end
end
