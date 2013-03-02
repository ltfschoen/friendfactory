class Biometric::Value < ActiveRecord::Base

  self.table_name = "signals"
  self.inheritance_column = nil

  validates_presence_of :name, :display_name

  has_many :domain_values,
      :class_name => 'Biometric::DomainValue',
      :foreign_key => 'signal_id'

  has_many :domains, :through => :domain_values

  alias_attribute :to_s, :name

end
