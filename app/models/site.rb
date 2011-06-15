class Site < ActiveRecord::Base  

  TemplateSiteName = 'friskyfactory'

  validates_presence_of   :name, :display_name
  validates_uniqueness_of :name

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

  has_many :signal_categories,
      :class_name  => 'Signal::Category',
      :foreign_key => 'site_id' do
    def clone
      all.map(&:clone)
    end
  end
  
  has_many :signal_categories_signals,
      :class_name => 'Signal::CategorySignal',
      :through    => :signal_categories,
      :source     => :categories_signals
      
  has_many :assets
  accepts_nested_attributes_for :assets, :allow_destroy => true, :reject_if => :all_blank

  after_create :create_home_wave

  def signals
    Signal::Base.find_all_by_id(signal_categories_signals.map(&:signal_id))
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

  def home_wave
    waves.type(Wave::Community).where(:slug => Wave::CommunitiesController::DefaultWaveSlug).order('created_at desc').limit(1).try(:first)
  end
  
  def self.template
    Site.find_by_name(Site::TemplateSiteName) || raise("No template site")
  end
  
  def clone
    super.tap do |clone|
      clone.name, clone.display_name = nil, nil
      clone.signal_categories = self.signal_categories.clone
    end
  end
  
  private
  
  def create_home_wave
    unless waves.type(Wave::Community).find_by_slug(Wave::CommunitiesController::DefaultWaveSlug).present?
      wave = Wave::Community.new(:slug => Wave::CommunitiesController::DefaultWaveSlug)
      self.waves << wave
      wave.publish!
      wave
    end
  end
  
  def raise_exception_if_signal_already_applied(signal)
    raise "Signal already exists for site" if signals.where(:id => signal.id)
  end
  
end
