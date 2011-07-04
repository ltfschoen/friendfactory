class Posting::Link < Posting::Base
  alias_attribute :url, :body
  attr_readonly :user_id
  attr_accessible :subject, :url
  validates_presence_of :url
  validates_presence_of :user
end
