class Signal::Category < ActiveRecord::Base
  set_table_name :signal_categories
  validates_presence_of :name
  
  belongs_to :site
  
  has_many :categories_signals,
      :class_name  => 'Signal::CategorySignal',
      :foreign_key => 'category_id',
      :dependent   => :destroy do
    def clone
      all.map(&:clone)
    end
  end
  
  has_many :signals,
      :through   => :categories_signals,
      :order     => '`signal_categories_signals`.`ordinal` asc',
      :before_add => :validate_uniqueness_of_signal
    
  def clone
    super.tap do |clone|
      clone.site_id = nil
      clone.categories_signals = self.categories_signals.clone
    end
  end
  
  private
  
  def validate_uniqueness_of_signal(signal)
    raise "Signal already in category" if signals.where(:id => signal.id).present?
  end  
end
