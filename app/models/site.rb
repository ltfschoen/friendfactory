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

  def home_wave
    waves.site(self).type(Wave::Community).published.order('created_at asc').limit(1).try(:first)
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
  
  def create_default_wave
    unless waves.type(Wave::Community).find_by_slug(Wave::CommunitiesController::DefaultWaveSlug).present?
      wave = Wave::Community.new(:slug => Wave::CommunitiesController::DefaultWaveSlug)
      self.waves << wave
      wave.publish!
      wave
    end
  end
  
end
