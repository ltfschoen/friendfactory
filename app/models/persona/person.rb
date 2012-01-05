class Persona::Person < Persona::Base

  attr_accessible \
      :first_name,
      :last_name,
      :description,
      :age,
      :location,
      :dob,
      :biometric_values_attributes

  validates_presence_of :handle
  validates_presence_of :age, :location, :on => :create

  has_many :biometric_person_values,
      :class_name  => 'Biometric::PersonValue',
      :foreign_key => 'person_id',
      :autosave    => true

  alias :biometric_values :biometric_person_values

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

  def first_name
    self[:first_name].present? ? self[:first_name].strip.titleize : handle
  end

  def last_name
    self[:last_name].strip.titleize if self[:last_name].present?
  end

  def full_name
    [ first_name, last_name ].compact.join(' ')
  end

end
