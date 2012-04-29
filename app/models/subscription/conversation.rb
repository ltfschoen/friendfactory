class Subscription::Conversation < Subscription::Base

  LastNotifiedHoursAgo = 4

  scope :notify?, lambda { where('`notified_at` < ?', LastNotifiedHoursAgo.hours.ago.utc) }

end
