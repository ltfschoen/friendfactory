class Posting::Photo < Posting::Base

  has_attached_file :image,
      :styles => { :h480 => 'x480', :iphone => '320x480#', :ad => '300x250#', :square => '48x48!' },
      :default_style => :h480
  
  validates_attachment_presence     :image
  validates_attachment_size         :image, :less_than => 5.megabytes
  validates_attachment_content_type :image, :content_type => [ 'image/jpeg', 'image/png', 'image/pjpeg', 'image/x-png' ]

end
