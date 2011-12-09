class Biometric::DomainValue < ActiveRecord::Base

  set_table_name :signal_categories_signals

  belongs_to :domain,
      :class_name  => 'Biometric::Domain',
      :foreign_key => 'category_id'

  belongs_to :value,
      :class_name  => 'Biometric::Value',
      :foreign_key => 'signal_id'

  alias_attribute :domain_id, :category_id
  alias_attribute :value_id, :signal_id

  before_create :initialize_ordinal

  def initialize_ordinal
    if domain.present? && ordinal.blank?
      self.ordinal = domain.domain_values.count
    end
  end

  private :initialize_ordinal

end
