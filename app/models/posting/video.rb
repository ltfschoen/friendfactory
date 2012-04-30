require 'primed_at'

class Posting::Video < Posting::Base

  include PrimedAt

  VALID_URLS = [
    /^(http:\/\/)?(www\.)?youtube\.com\/watch[\\?&]v=([^&#]{11})$/, # youtube.com
    /^(http:\/\/)?(www\.)?youtu\.be\/([^&#]{11})$/ # youtu.be
  ]

  alias_attribute :url, :body

  attr_accessible :subject, :url

  validates_presence_of :url
  validates_presence_of :user

  validate do |posting|
    if posting.url.present? && posting.vid.blank?
      posting.errors.add(:url, 'not recognized')
    end
  end

  def self.subscription_class
    Subscription::Comment
  end

  def vid
    VALID_URLS.each do |valid_url|
      if match = valid_url.match(url)
        return match[3]
      end
    end
    nil
  end

end
