class Biometric::Domain < ActiveRecord::Base

  set_table_name :signal_categories
  validates_presence_of :name

  before_validation :initialize_name
  before_create :initialize_ordinal

  private

  def initialize_name
    if name.blank?
      self.name = display_name.underscore.downcase.gsub(/\s/, '_')
    end
  end

  def initialize_ordinal
    if site_id.present? && ordinal.blank?
      self.ordinal = site.biometric_domains.count
    end
  end

  public

  belongs_to :site

  has_many :domain_values,
      :class_name  => 'Biometric::DomainValue',
      :foreign_key => 'category_id',
      :dependent   => :delete_all,
      :order       => '"signal_categories_signals"."ordinal" ASC',
      :autosave    => true

  has_many :values,
      :through => :domain_values,
      :order   => '"signal_categories_signals"."ordinal" ASC'

  alias :range :values

  def domain_values_attributes=(attributes)
    new_value_ids = attributes[:signal_id].select{ |v| v.present? }.map(&:to_i)
    new_value_ids = new_value_ids.inject({ :existing => [], :create => []}) do |memo, new_value_id|
      memo[value_ids.include?(new_value_id) ? :existing : :create] << new_value_id
      memo
    end
    destroy_value_ids = value_ids - new_value_ids[:existing]
    destroy_domain_values = domain_values.where(:signal_id => destroy_value_ids)
    domain_values.delete(destroy_domain_values)
    domain_values.build(new_value_ids[:create].map{ |id| { :signal_id => id }})
  end

  alias_attribute :to_s, :name

end
