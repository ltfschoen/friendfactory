class Posting::Avatar < Posting::Base

  has_attached_file :image,
      :styles => {
          :thumb    => [ '100x100#', :jpg ],
          :portrait => [ '200x280#', :jpg ],
          :polariod => [ '260x280#', :jpg ],
          :iphone   => [ '320x480#', :jpg ],
          :iphoneR  => [ '480x320#', :jpg ],
          :ad       => [ '300x250#', :jpg ]},
      :default_style => :portrait,
      # :default_style => :thumb,
      :convert_options => { :all => [ '-strip', '-depth 8' ] }
  
  validates_attachment_presence     :image
  validates_attachment_size         :image, :less_than => 5.megabytes
  validates_attachment_content_type :image, :content_type => [ 'image/jpeg', 'image/png', 'image/pjpeg', 'image/x-png' ]

  def before_create
    self.active = true
  end
  
end
