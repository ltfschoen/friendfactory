class Posting::Photo < Posting::Base

  has_attached_file :image,
      :styles => {
          :h4x6    => [ '460x310#', :jpg ],
          :v4x6    => [ '310x460#', :jpg ],
          :w460    => [ '460',      :jpg ], # Slideshow
          :thumb   => [ '100x100#', :jpg ],
          :iphone  => [ '320x480#', :jpg ],
          :iphoneR => [ '480x320#', :jpg ],
          :ad      => [ '300x250#', :jpg ]},
      :default_style => :'h4x6',
      :convert_options => { :all => [ '-strip', '-depth 8' ] }

  validates_attachment_presence     :image
  validates_attachment_size         :image, :less_than => 5.megabytes
  validates_attachment_content_type :image, :content_type => [ 'image/jpeg', 'image/png', 'image/pjpeg', 'image/x-png' ]

  before_create :set_dimensions
  before_create :randomize_file_name
  
  def distribute(sites)
    sites.each do |site|
      if profile = user.profile(site)
        profile.postings << self
      end
    end
    super
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
  end
  
  def randomize_file_name
    extension = File.extname(image_file_name).downcase
    self.image.instance_write(:file_name, "#{ActiveSupport::SecureRandom.hex(16)}#{extension}")
  end

end
