require 'primed_at'

class Posting::PostIt < Posting::Base

  include PrimedAt

  acts_as_commentable

  attr_accessible :subject

  validates_presence_of :subject, :user_id

end
