class Site < ActiveRecord::Base  

  TemplateSiteName = 'friskyfactory'
  DefaultMailer    = 'mailer@friskyfactory.com'

  validates_presence_of :name, :display_name
  validates_uniqueness_of :name

  has_many :users
  authenticates_many :user_sessions

  has_and_belongs_to_many :waves,
      :class_name              => 'Wave::Base',
      :join_table              => 'sites_waves',
      :foreign_key             => 'site_id',
      :association_foreign_key => 'wave_id'

  has_many :invitations, :foreign_key => 'resource_id', :class_name => 'Posting::Invitation'

  has_many :signal_categories,
      :class_name  => 'Signal::Category',
      :foreign_key => 'site_id',
      :order       => 'ordinal asc',
      :dependent   => :destroy do
    def clone(*category_names)
      (category_names.empty? ? all : where('`signal_categories`.`name` in (?)', category_names.map(&:to_s))).map(&:clone)
    end
  end

  has_many :signal_categories_signals,
      :class_name => 'Signal::CategorySignal',
      :through    => :signal_categories,
      :source     => :categories_signals

  has_many :assets, :class_name => 'Asset::Base' do
    def [](name)
      scoped_by_name(name).order('`assets`.`created_at` desc').limit(1).first
    end    
  end

  has_many :stylesheets, :order => '`controller_name` asc'
  has_many :images, :class_name => 'Asset::Image'
  has_many :constants, :class_name => 'Asset::Constant'
  has_many :texts, :class_name => 'Asset::Text'

  def stylesheet(controller_name = nil)
    stylesheets = self.stylesheets.scoped
    if controller_name.present?
      stylesheets = stylesheets.where('(`controller_name` is null) or (`controller_name` = ?)', controller_name)
    end
    stylesheets.map(&:css).compact.join("\n")
  end

  with_options :allow_destroy => true, :reject_if => :all_blank do
    accepts_nested_attributes_for :stylesheets
    accepts_nested_attributes_for :images
    accepts_nested_attributes_for :constants
    accepts_nested_attributes_for :texts
  end

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

  def mailer
    self[:mailer].present? ? self[:mailer] : DefaultMailer
  end

  def home_wave
    @home_wave ||= waves.type(Wave::Community).where(:slug => Wave::CommunitiesController::DefaultWaveSlug).order('created_at desc').limit(1).first
  end

  def clone
    super.tap do |clone|
      clone.name, clone.display_name = nil, nil
      clone.signal_categories = self.signal_categories.clone
    end
  end

  def self.template
    Site.find_by_name(Site::TemplateSiteName) || raise("No template site")
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
