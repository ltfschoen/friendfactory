class Site < ActiveRecord::Base  

  validates_presence_of :name

  has_many :invitations, :as => :resource, :class_name => 'Posting::Invitation' do
    def anonymous(code)
      where(:subject => code, :body => nil).order('created_at desc').limit(1).try(:first)
    end
  end
  
  has_and_belongs_to_many :users
  
  has_and_belongs_to_many :waves,
      :class_name              => 'Wave::Base',
      :join_table              => 'sites_waves',
      :foreign_key             => 'site_id',
      :association_foreign_key => 'wave_id'
  
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
