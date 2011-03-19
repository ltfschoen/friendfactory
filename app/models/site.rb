class Site < ActiveRecord::Base  

  validates_presence_of :name

  has_and_belongs_to_many :users
  
  has_and_belongs_to_many :waves,
      :class_name              => 'Wave::Base',
      :join_table              => 'sites_waves',
      :foreign_key             => 'site_id',
      :association_foreign_key => 'wave_id' do
    def type(type)
      where(:type => type)
    end
  end
  
  def to_s
    name
  end
  
  def layout
    name
  end

end
