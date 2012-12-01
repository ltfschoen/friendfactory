require 'primed_at'

class Posting::Photo < Posting::Base

  include PrimedAt

  self.include_root_in_json = false

  has_attached_file :image,
      :styles => {
          :h4x6    => [ '460x310#', :jpg ],
          :v4x6    => [ '310x460#', :jpg ],
          :h4x6s   => [ '150x100#', :jpg ],
          :v4x6s   => [ '68x100#',  :jpg ],
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

  subscribable :comment, :user

  def as_json(*args)
    opts = args.extract_options!
    if opts.delete(:fetch)
      super(:only => [ :id ], :methods => [ :fetched_image_path, :orientation ])
    else
      super(:only => [ :id, :horizontal ], :methods => [ :photo_picker_image_path, :hashed_image_path ])
    end
  end

  def image_path
    image.url(best_orientation_style)
  end

  def hash_path
    "/h/#{hash_key}"
  end

  def hashed_image_path
    "#{hash_path}/#{best_orientation_style}"
  end

  def photo_picker_image_path
    "#{hash_path}/thumb"
  end

  def fetched_image_path
    image.url(best_orientation_small_style)
  end

  def best_orientation_style
    horizontal ? :h4x6 : :v4x6
  end

  def vertical?
    !horizontal? && 'vertical'
  end

  alias_method :orientation, :best_orientation_style

  private

  def best_orientation_small_style
    "#{best_orientation_style.to_s}s".to_sym
  end

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
    self.image.instance_write(:file_name, "#{SecureRandom.hex(16)}#{extension}")
  end

end
