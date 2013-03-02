class Signal::Base < ActiveRecord::Base
  self.table_name = "signals"
  validates_presence_of :name, :display_name
  has_many :category_signals, :class_name => 'Signal::CategorySignal', :foreign_key => 'signal_id'
  has_many :categories, :through => :category_signals
  def sites
    Site.find_all_by_id(categories.map(&:site_id))
  end
end
