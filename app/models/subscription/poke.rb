class Subscription::Poke < Subscription::Base

  AccumulatePokes = 1

  def self.tally(subscriptions)
    related_subscriptions = related_subscriptions(subscriptions)
    if related_subscriptions.length > (AccumulatePokes - 1)
      update_all({ :state => :disabled }, { :id => related_subscriptions.map(&:id) })
      subscriptions
    else
      []
    end
  end

  def notified!
    super
    disable!
  end

  private

  def self.related_subscriptions(subscriptions)
    subscriptions.map{ |subscription| subscription.related.enabled.notify? }.flatten
  end

end
