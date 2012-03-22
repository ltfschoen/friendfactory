require 'primed_at'

class Posting::PostIt < Posting::Base

  include PrimedAt

  attr_accessible :subject

  validates_presence_of :subject, :user_id

end
