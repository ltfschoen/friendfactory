class Signal::Base < ActiveRecord::Base
  set_table_name :signals    
  validates_presence_of :name, :display_name

  has_many :category_signals, :class_name => 'Signal::CategorySignal', :foreign_key => 'signal_id'
  has_many :categories, :through => :category_signals
  has_many :sites, :through => :category_signals
end
