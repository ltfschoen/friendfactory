class Subscription::Conversation < Subscription::Base

  LastNotifiedHoursAgo = 4

  scope :notify?, lambda {
    unless Rails.configuration.ignore_recipient_emailability
      where('("notified_at" IS NULL) OR ("notified_at" < ?)', LastNotifiedHoursAgo.hours.ago.utc)
    end
  }

end
