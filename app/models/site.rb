class Site < ActiveRecord::Base  

  validates_presence_of :name

  has_and_belongs_to_many :users
  
  has_and_belongs_to_many :waves,
      :class_name              => 'Wave::Base',
      :join_table              => 'sites_waves',
      :foreign_key             => 'site_id',
      :association_foreign_key => 'wave_id' do
    def type(*types)
      where('type in (?)', types.map(&:to_s))
    end  
  end
  
  def to_s
    name
  end
  
  def layout
    name
  end
  
  def to_sym
    name.to_sym
  end
  
  alias :intern :to_sym
  
end
