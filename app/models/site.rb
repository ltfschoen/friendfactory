class Site < ActiveRecord::Base

  TemplateSiteName    = 'friskyfactory'
  DefaultMailer       = 'mailer@friskyfactory.com'
  DefaultHomeWaveSlug = 'popular'

  validates_presence_of :name, :display_name
  validates_uniqueness_of :name

  belongs_to :home_user,
      :class_name  => 'Personage',
      :foreign_key => 'user_id'

  has_many :users

  authenticates_many :user_sessions

  has_and_belongs_to_many :waves,
      :class_name              => 'Wave::Base',
      :join_table              => 'sites_waves',
      :foreign_key             => 'site_id',
      :association_foreign_key => 'wave_id'

  has_many :invitations,
      :class_name  => 'Invitation::Base'

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

  def home_wave
    home_user.profile
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

end
