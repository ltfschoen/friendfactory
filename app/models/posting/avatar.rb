class Posting::Avatar < Posting::Base

  has_attached_file :image,
      :styles => {
          :thumb     => [ '128x128#', :jpg ],
          :thumbbw   => [ '128x128#', :jpg ],
          :thimble   => [ '32x32#',   :jpg ],
          :thimblebw => [ '32x32#',   :jpg ],
          :portrait  => [ '200x280#', :jpg ],
          :polaroid  => [ '260x260#', :jpg ]},
      :default_style => :portrait,
      :convert_options => {
          :all       => [ '-strip', '-depth 8' ],
          :thumbbw   => [ '-transparent white', '-colorspace gray' ],
          :thimblebw => [ '-transparent white', '-colorspace gray' ]
      }

  validates_attachment_presence     :image
  validates_attachment_size         :image, :less_than => 5.megabytes
  validates_attachment_content_type :image, :content_type => [ 'image/jpeg', 'image/png', 'image/pjpeg', 'image/x-png' ]

  before_create :set_dimensions
  before_create :randomize_file_name
  before_create :set_hash_key

  delegate :profile, :to => :user

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
