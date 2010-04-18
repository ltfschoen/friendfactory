class Posting::Text < Posting::Base
  validates_presence_of :body
end
