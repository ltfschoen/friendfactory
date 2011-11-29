class Person < ActiveRecord::Base

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

  attr_accessible :handle, :age, :location

  validates_presence_of :handle, :age, :location

  belongs_to :user
  has_one :profile, :class_name => 'Wave::Profile', :foreign_key => 'resource_id'

  after_create :create_profile_wave

  def create_profile_wave
    profile = build_profile
    profile.person_id = self.id
    profile.user_id = self.user_id
    profile.save && profile
  end

  private :create_profile_wave

  def handle
    (self[:handle].try(:strip) || first_name)
  end

  def first_name
    self[:first_name].try(:strip).try(:titleize)
  end

  def last_name
    self[:last_name].try(:strip).try(:titleize)
  end

  def full_name
    [ first_name, last_name ].compact.join(' ')
  end

end
