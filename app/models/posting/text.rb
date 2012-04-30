require 'primed_at'

class Posting::Text < Posting::Base

  include PrimedAt

  def self.subscription_class
    Subscription::Comment
  end

end