require 'primed_at'

class Posting::Text < Posting::Base

  include PrimedAt

  acts_as_commentable

end