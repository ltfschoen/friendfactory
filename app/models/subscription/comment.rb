class Subscription::Comment < Subscription::Base

  LastNotifiedHoursAgo = 1

  scope :notify?, lambda {
    unless super
      where('(`notified_at` IS NULL) OR (`notified_at` < ?)', LastNotifiedHoursAgo.hours.ago.utc)
    end
  }

end
