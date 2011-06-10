class Signal::Category < ActiveRecord::Base
  set_table_name :signal_categories
  validates_presence_of :name
  
  belongs_to :site
  
  has_many :category_signals,
      :class_name  => 'Signal::CategorySignal',
      :foreign_key => 'category_id'
  
  has_many :signals,
      :through   => :category_signals,
      :order     => '`signal_categories_signals`.`ordinal` asc',
      :before_add => :validate_uniqueness_of_signal,
      :after_add => :set_site_on_signals_categories
  
  scope :subject_type, lambda { |*subject_types| where('`signal_categories`.`subject_type` in (?)', subject_types.map(&:to_s)) }
  
  private
  
  def validate_uniqueness_of_signal(signal)
    raise "Signal already in category" if signals.where(:id => signal.id).present?
  end
  
  def set_site_on_signals_categories(signal)
    category_signals.where(:signal_id => signal.id).first.update_attribute(:site_id, self[:site_id])
  end
  
end
