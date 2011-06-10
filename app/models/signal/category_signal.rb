class Signal::CategorySignal < ActiveRecord::Base
  set_table_name :signal_categories_signals
  belongs_to :category, :class_name => 'Signal::Category', :foreign_key => 'category_id'
  belongs_to :signal, :class_name => 'Signal::Base', :foreign_key => 'signal_id'
  belongs_to :site
end
