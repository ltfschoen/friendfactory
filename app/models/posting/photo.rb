class Posting::Photo < Posting::Base

  has_attached_file :image,
      :styles => {
          :h480     => [ 'x480',     :png ],
          :w460     => [ '460',      :png ],
          :iphone   => [ '320x480#',  :png ],
          :iphoneR  => [ '480x320#',  :png ],
          :iPad     => [ '768x1024#', :png ],
          :iPadR    => [ '1024x768#', :png ],
          :small    => [ '130x130',  :png ],
          :ad       => [ '300x250#', :png ]},
      :default_style => :h480
  
  validates_attachment_presence     :image
  validates_attachment_size         :image, :less_than => 5.megabytes
  validates_attachment_content_type :image, :content_type => [ 'image/jpeg', 'image/png', 'image/pjpeg', 'image/x-png' ]
  
  has_and_belongs_to_many :profiles,
      :class_name  => 'Wave::Profile',
      :join_table  => 'postings_profiles',
      :foreign_key => 'posting_id'

end
