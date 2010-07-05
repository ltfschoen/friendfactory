class Posting::Photo < Posting::Base

  has_attached_file :image,
      :styles => {
          :polaroid => [ '350x425#',  :png ],
          :'4x6'    => [ '600x400#',  :png ],
          :h480     => [ 'x480',      :png ], # For horizontal grid display
          :w460     => [ '460',       :png ], # For album
          :iphone   => [ '320x480#',  :png ],
          :iphoneR  => [ '480x320#',  :png ]},
      :default_style => :polaroid
  
  validates_attachment_presence     :image
  validates_attachment_size         :image, :less_than => 5.megabytes
  validates_attachment_content_type :image, :content_type => [ 'image/jpeg', 'image/png', 'image/pjpeg', 'image/x-png' ]
  
  has_and_belongs_to_many :profiles,
      :class_name  => 'Wave::Profile',
      :join_table  => 'postings_profiles',
      :foreign_key => 'posting_id'

end
