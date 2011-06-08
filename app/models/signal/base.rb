class Signal::Base < ActiveRecord::Base
  set_table_name :signals
  validates_presence_of :name, :display_name
  
  has_many :ranges,
      :class_name => 'Signal::Range',
      :foreign_key => 'signal_id'
      
  has_and_belongs_to_many :sites,
      :join_table              => 'sites_signals',
      :foreign_key             => 'signal_id',
      :association_foreign_key => 'site_id'      
end
