class Posting::Avatar < Posting::Base

  attr_accessor :current_profile

  has_attached_file :image,
      :styles => {
          :thumb    => [ '100x100#', :jpg ],
          :portrait => [ '200x280#', :jpg ],
          :polaroid => [ '260x260#', :jpg ],
          :iphone   => [ '320x480#', :jpg ],
          :iphoneR  => [ '480x320#', :jpg ],
          :ad       => [ '300x250#', :jpg ]},
      :default_style => :portrait,
      :convert_options => { :all => [ '-strip', '-depth 8' ] }
  
  validates_attachment_presence     :image
  validates_attachment_size         :image, :less_than => 5.megabytes
  validates_attachment_content_type :image, :content_type => [ 'image/jpeg', 'image/png', 'image/pjpeg', 'image/x-png' ]

  before_create :set_dimensions  
  before_create :randomize_file_name
  
  scope :activated, where(:active => true)

  def profile(site = nil)
    site.nil? ? current_profile : waves.type(Wave::Profile).site(site).order('`waves`.`created_at` desc').limit(1).first
  end

  def profile_id(site = nil)
    profile(site).try(:id)
  end

  def url(style = nil)
    image.url(style)
  end

  def silhouette?
    false
  end

  private
  
  def set_dimensions
    tempfile = self.image.queued_for_write[:original]    
    unless tempfile.nil?
      dimensions = Paperclip::Geometry.from_file(tempfile)
      self.width = dimensions.width
      self.height = dimensions.height
      self.horizontal = dimensions.horizontal?
    end
    true
  end

  def randomize_file_name
    extension = File.extname(image_file_name).downcase
    self.image.instance_write(:file_name, "#{ActiveSupport::SecureRandom.hex(16)}#{extension}")
  end

end
