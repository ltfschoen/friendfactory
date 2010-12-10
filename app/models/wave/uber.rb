class Wave::Uber < Wave::Base
  
  has_and_belongs_to_many :waves,
      :join_table              => 'uber_waves',
      :foreign_key             => 'uber_wave_id',
      :class_name              => 'Wave::Base',
      :association_foreign_key => 'wave_id',
      :order                   => 'updated_at desc'
  
end