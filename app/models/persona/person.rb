require 'empty_avatar'

class Persona::Person < Persona::Base

  attr_accessible \
      :handle,
      :first_name,
      :last_name,
      :description,
      :age,
      :location,
      :dob,
      :avatar_id,
      :biometric_values_attributes

  validates_presence_of \
      :handle,
      :age,
      :location

  belongs_to :user

  has_one :profile,
      :class_name  => 'Wave::Profile',
      :foreign_key => 'resource_id'

  belongs_to :avatar,
      :class_name => 'Posting::Avatar',
      :conditions => { :state => :published }

  def avatar?
    avatar.present?
  end

  has_many :biometric_person_values,
      :class_name  => 'Biometric::PersonValue',
      :foreign_key => 'person_id',
      :autosave    => true

  alias :biometric_values :biometric_person_values

  after_create :create_profile_wave

  def biometric_values_attributes=(attributes)
    attributes.each do |domain_id, value_id|
      if domain_id.present? && value_id.present?
        if person_value = biometric_values.find_by_domain_id(domain_id)
          person_value.update_attribute(:value_id, value_id)
        else
          biometric_values.build(:domain_id => domain_id, :value_id => value_id)
        end
      end
    end
  end

  def biometric_value_id(domain)
    if person_value = biometric_person_values.domain(domain).first
      person_value.value_id
    end
  end

  def handle
    self[:handle].strip if self[:handle].present?
  end

  def first_name
    self[:first_name].present? ? self[:first_name].strip.titleize : handle
  end

  def last_name
    self[:last_name].strip.titleize if self[:last_name].present?
  end

  def full_name
    [ first_name, last_name ].compact.join(' ')
  end

  def avatar_with_silhouette
    avatar_without_silhouette || EmptyAvatar.new(self)
  end

  alias_method_chain :avatar, :silhouette

  private

  def create_profile_wave
    profile = build_profile
    profile.person_id = self.id
    profile.user_id = self.user_id
    profile.save && profile
  end

end
