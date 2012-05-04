require 'primed_at'

class Posting::Text < Posting::Base

  include PrimedAt

  subscribable :comment, :user

end