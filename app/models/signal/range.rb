class Signal::Range < ActiveRecord::Base
  set_table_name :signal_ranges
  validates_presence_of :signal_id, :name, :display_name
  belongs_to :signal, :class_name => 'Signal::Base', :foreign_key => 'signal_id'
end
