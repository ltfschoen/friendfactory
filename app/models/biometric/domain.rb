class Biometric::Domain < ActiveRecord::Base

  set_table_name :signal_categories
  validates_presence_of :name

  belongs_to :site

  has_many :domain_values,
      :class_name  => 'Biometric::DomainValue',
      :foreign_key => 'category_id'

  has_many :values,
      :through => :domain_values,
      :order   => '`signal_categories_signals`.`ordinal` asc'

  alias :range :values

  alias_attribute :to_s, :name

end