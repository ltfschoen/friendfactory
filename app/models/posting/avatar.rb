class Posting::Avatar < Posting::Base

  RepublishDuration = 6.hours
  
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
  
  def distribute(sites)
    sites.each do |site|
      if wave = site.waves.find_by_slug(Wave::CommunitiesController::DefaultWaveSlug)
        postings_to_remove = wave.postings.
            where(:user_id => self.user_id, :type => Posting::Avatar, :created_at => (Time.now - RepublishDuration)..Time.now)
        wave.postings.delete(postings_to_remove)
        wave.postings << self
      end
    end
    super
  end

  def profile
    waves.type(Wave::Profile).limit(1).first
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
