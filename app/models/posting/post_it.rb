class Posting::PostIt < Posting::Base

  attr_accessible :subject  
  validates_presence_of :subject, :user_id

  publish_to :wave => Wave::Profile

end
