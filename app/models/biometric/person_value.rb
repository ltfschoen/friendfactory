class Biometric::PersonValue < ActiveRecord::Base

  set_table_name :biometric_people_values

  belongs_to :person

  belongs_to :domain,
      :class_name  => 'Biometric::Domain',
      :foreign_key => 'domain_id'

  belongs_to :value,
      :class_name => 'Biometric::Value',
      :foreign_key => 'value_id'

  scope :domain, lambda { |domain| where(:domain_id => domain.id).limit(1) }

end