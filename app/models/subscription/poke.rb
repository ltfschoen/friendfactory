class Subscription::Poke < Subscription::Base

  AccumulatePokesCount = 2
  DisableRelatedSubscriptions = false

  def self.tally(subscriptions)
    tallied_subscriptions = active_user_subscriptions(subscriptions)
    tallied_subscriptions = accumulated_pokes_subscriptions(subscriptions) if tallied_subscriptions.empty?
    tallied_subscriptions
  end

  def notified
    disable! if DisableRelatedSubscriptions
    super
  end

  private

  def self.active_user_subscriptions(subscriptions)
    subscriptions.select { |subscription| ! subscription.user.avatar.silhouette? }
  end

  def self.accumulated_pokes_subscriptions(subscriptions)
    related_subscriptions = related_subscriptions(subscriptions)
    if related_subscriptions.length > (AccumulatePokesCount - 1)
      disable_all(related_subscriptions)
      subscriptions
    else
      []
    end
  end

  def self.related_subscriptions(subscriptions)
    subscriptions.map{ |subscription| subscription.related.enabled.notify? }.flatten
  end

  def self.disable_all(subscriptions)
    if DisableRelatedSubscriptions
      update_all({ :state => :disabled }, { :id => subscriptions.map(&:id) })
    end
  end

end
