class Site < ActiveRecord::Base

  DefaultMailer       = 'mailer@friskyfactory.com'
  DefaultHomeWaveSlug = 'popular'

  validates_presence_of :name, :display_name

  validates_uniqueness_of :name

  validates_presence_of :email_domain_display_name, :if => lambda { |site| site.email_domain_regex.present? }

  ###

  belongs_to :home_user,
      :class_name  => 'Personage',
      :foreign_key => 'user_id'

  def home_wave
    home_user.profile
  end

  def create_home!(user, handle)
    if user[:site_id] == self[:id]
      personage = user.personages.create!(:persona_attributes => { :type => 'Persona::Community', :handle => handle, :emailable => true })
      update_attribute(:home_user, personage)
      personage
    end
  end

  ###

  has_many :users

  authenticates_many :user_sessions

  def build_user(handle, email, password, *opts)
    persona_attributes = opts.extract_options!
    persona_attributes.merge!(:handle => handle).reverse_merge!(:type => 'Persona::Person', :emailable => true)
    admin = opts.first
    user  = users.build({
        :email                        => email,
        :password                     => password,
        :password_confirmation        => password,
        :default_personage_attributes => {
            :default            => true,
            :persona_attributes => persona_attributes }})
    user.admin = admin
    user
  end

  def create_user!(handle, email, password, *opts)
    build_user(handle, email, password, false, *opts).save!
  end

  def create_admin_user!(handle, email, password, *opts)
    build_user(handle, email, password, true, *opts).save!
  end

  ###

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

  accepts_nested_attributes_for :biometric_domains,
      :reject_if     => :all_blank,
      :allow_destroy => true

  has_many :assets, :class_name => 'Asset::Base' do
    def [](name)
      scoped_by_name(name).order('`assets`.`created_at` desc').limit(1).first
    end
  end

  has_many :stylesheets, :order => '`controller_name` asc'

  has_many :images,    :class_name => 'Asset::Image'
  has_many :constants, :class_name => 'Asset::Constant'
  has_many :texts,     :class_name => 'Asset::Text'

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

  ###

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

  def domain_name
    if analytics_domain_name
      analytics_domain_name.gsub(/^\.+/, '')
    end
  end

  def help_email
    "help@#{domain_name}"
  end

end
