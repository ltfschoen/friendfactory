class Site < ActiveRecord::Base

  TemplateSiteName    = 'friskyfactory'
  DefaultMailer       = 'mailer@friskyfactory.com'
  DefaultHomeWaveSlug = 'popular'

  validates_presence_of :name, :display_name
  validates_uniqueness_of :name

  has_many :users
  authenticates_many :user_sessions

  has_and_belongs_to_many :waves,
      :class_name              => 'Wave::Base',
      :join_table              => 'sites_waves',
      :foreign_key             => 'site_id',
      :association_foreign_key => 'wave_id'

  has_and_belongs_to_many :profiles,
      :class_name              => 'Wave::Profile',
      :join_table              => 'sites_waves',
      :foreign_key             => 'site_id',
      :association_foreign_key => 'wave_id'

  belongs_to :home_wave,
      :class_name  => 'Wave::Base',
      :foreign_key => 'home_wave_id'

  has_many :invitations, :foreign_key => 'resource_id', :class_name => 'Posting::Invitation'

  # TODO Remove
  has_many :signal_categories,
      :class_name  => 'Signal::Category',
      :foreign_key => 'site_id',
      :order       => 'ordinal asc',
      :dependent   => :destroy do
    def clone(*category_names)
      (category_names.empty? ? all : where('`signal_categories`.`name` in (?)', category_names.map(&:to_s))).map(&:clone)
    end
  end

  # TODO Remove
  has_many :signal_categories_signals,
      :class_name => 'Signal::CategorySignal',
      :through    => :signal_categories,
      :source     => :categories_signals

  has_many :biometric_domains,
      :class_name  => 'Biometric::Domain',
      :foreign_key => 'site_id',
      :order       => '`ordinal` ASC'

  accepts_nested_attributes_for :biometric_domains, :reject_if => :all_blank, :allow_destroy => true

  has_many :assets, :class_name => 'Asset::Base' do
    def [](name)
      scoped_by_name(name).order('`assets`.`created_at` desc').limit(1).first
    end
  end

  has_many :stylesheets, :order => '`controller_name` asc'
  has_many :images, :class_name => 'Asset::Image'
  has_many :constants, :class_name => 'Asset::Constant'
  has_many :texts, :class_name => 'Asset::Text'

  with_options :allow_destroy => true, :reject_if => :all_blank do |opts|
    opts.accepts_nested_attributes_for :stylesheets
    opts.accepts_nested_attributes_for :images
    opts.accepts_nested_attributes_for :constants
    opts.accepts_nested_attributes_for :texts
  end

  def stylesheet(controller_name = nil)
    stylesheets = self.stylesheets.scoped
    if controller_name.present?
      stylesheets = stylesheets.where('(`controller_name` is null) or (`controller_name` = ?)', controller_name)
    end
    stylesheets.map(&:css).compact.join("\n")
  end

  before_create :create_home_wave

  def signals
    Signal::Base.find_all_by_id(signal_categories_signals.map(&:signal_id))
  end

  def layout
    name
  end

  def to_s
    name
  end

  def to_sym
    name.to_sym
  end

  alias :intern :to_sym

  def mailer
    self[:mailer].present? ? self[:mailer] : DefaultMailer
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

  def create_home_wave_with_slug
    unless self[:home_wave_id].present?
      create_home_wave_without_slug(:slug => DefaultHomeWaveSlug).publish!
    end
  end

  alias_method_chain :create_home_wave, :slug

  def raise_exception_if_signal_already_applied(signal)
    raise "Signal already exists for site" if signals.where(:id => signal.id)
  end

end
