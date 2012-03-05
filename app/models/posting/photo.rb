class Posting::Photo < Posting::Base

  self.include_root_in_json = false

  has_attached_file :image,
      :styles => {
          :h4x6    => [ '460x310#', :jpg ],
          :v4x6    => [ '310x460#', :jpg ],
          :w460    => [ '460',      :jpg ], # Slideshow
          :thumb   => [ '128x128#', :jpg ],
          :thumbbw => [ '128x128#', :jpg ]},
      :default_style => :'h4x6',
      :convert_options => {
          :all     => [ '-strip', '-depth 8' ],
          :thumbbw => [ '-transparent white', '-colorspace gray' ]
      }

  validates_attachment_presence     :image
  validates_attachment_size         :image, :less_than => 5.megabytes
  validates_attachment_content_type :image, :content_type => [ 'image/jpeg', 'image/jpg', 'image/png', 'image/pjpeg', 'image/x-png', 'image/gif' ]

  before_create :set_dimensions
  before_create :randomize_file_name
  before_create :set_hash_key

  def as_json(opts = nil)
    super(:only => [ :id, :horizontal ], :methods => [ :photo_picker_image_path, :hashed_image_path ])
  end

  def photo_picker_image_path  
    "/h/#{hash_key}/thumb" # image.url(:thumb)
  end

  def hashed_image_path
    "/h/#{hash_key}/#{best_orientation_style}"
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
    true # important!
  end

  def randomize_file_name
    extension = File.extname(image_file_name).downcase
    self.image.instance_write(:file_name, "#{ActiveSupport::SecureRandom.hex(16)}#{extension}")
  end

  def best_orientation_style
    horizontal ? :h4x6 : :v4x6
  end

  def set_hash_key
    self.hash_key = ActiveSupport::SecureRandom.hex(4)
  end

end
