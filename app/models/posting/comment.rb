class Posting::Comment < Posting::Base
  validates_presence_of :parent_id
end
