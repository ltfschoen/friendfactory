class Posting::Video < Posting::Base

  VALID_URLS = [
    /^(http:\/\/)?(www\.)?youtube\.com\/v=([^&#]{11})$/,  # youtube.com
    /^(http:\/\/)?(www\.)?youtu\.be\/([^&#]{11})$/        # youtu.be
  ]

  alias_attribute :url, :body
   
  attr_accessible :subject, :url
  
  validates_presence_of :url
  validates_presence_of :user
  
  attr_readonly :user_id
  
  validate do |posting|
    if posting.url.present?
      VALID_URLS.each do |valid_url|
        return if valid_url.match(posting.url).present?
      end
      posting.errors.add(:url, 'not recognized')
    end
  end
    
end
