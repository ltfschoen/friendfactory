class Posting::Photo < Posting::Base

  has_attached_file :image,
      :styles => {
          :'4x6'    => [ '400x260#', :jpg ],
          :h480     => [ 'x480',     :jpg ], # For horizontal grid display
          :w460     => [ '460',      :jpg ], # For album
          :iphone   => [ '320x480#', :jpg ],
          :iphoneR  => [ '480x320#', :jpg ],
          :ad       => [ '300x250#', :jpg ]},
      :default_style => :'4x6',
      :convert_options => { :all => [ '-strip', '-depth 8' ] }

  validates_attachment_presence     :image
  validates_attachment_size         :image, :less_than => 5.megabytes
  validates_attachment_content_type :image, :content_type => [ 'image/jpeg', 'image/png', 'image/pjpeg', 'image/x-png' ]

  before_create :set_dimensions
  
  has_and_belongs_to_many :profiles,
      :class_name  => 'Wave::Profile',
      :join_table  => 'postings_profiles',
      :foreign_key => 'posting_id'

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
end
