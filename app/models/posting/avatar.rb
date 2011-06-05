class Posting::Avatar < Posting::Base

  RepublishWindow = 6.hours
  
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
  
  scope :activated, where(:active => true)
  
  def distribute(sites)
    sites.each do |site|
      if wave = site.waves.find_by_slug(Wave::CommunitiesController::DefaultWaveSlug)
        wave.postings.type(Posting::Avatar).user(self.user).published.where(:created_at => (Time.now - RepublishWindow)...Time.now).map(&:unpublish!)
        wave.postings << self
      end
    end
    super
  end

  def profile(site)
    waves.type(Wave::Profile).site(site).order('created_at desc').limit(1).try(:first)
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

end
