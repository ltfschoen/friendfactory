module Subscribable
  def self.included(base)

    class << base
      attr_reader :subscription_class, :subscriber_attribute
      def subscribable(subscription_class_name, subscriber_attribute)
        @subscription_class = "subscription/#{subscription_class_name.to_s.downcase}".classify.constantize
        @subscriber_attribute = subscriber_attribute
      end
    end

    base.class_eval do
      def subscriber_attribute
        self.class.subscriber_attribute
      end

      def subscriber
        if subscriber_attribute
          subscriber_attribute.is_a?(Proc) ? subscriber_attribute.call(self) : self.send(subscriber_attribute)
        end
      end

      def subscriber?
        subscriber.present?
      end

      def subscription_class
        self.class.subscription_class
      end

      has_many :subscriptions,
          :as         => :resource,
          :class_name => "Subscription::Base",
          :order      => "created_at ASC",
          :dependent  => :destroy do
        def notify(opts = {})
          if klass = proxy_owner.subscription_class
            exclude_subscriber = opts.delete(:exclude)
            subscriptions = *klass.tally(scoped.merge(klass.enabled).merge(klass.notify?).merge(klass.exclude_subscriber(exclude_subscriber)))
            subscriptions.each do |subscription|
              if subscription.notifiable? && yield(subscription.subscriber)
                subscription.notified
              end
            end
          end
        end

        def create(subscriber)
          if subscriber && klass = proxy_owner.subscription_class
            scoped.subscriber(subscriber).limit(1).first || (proxy_owner.subscriptions << klass.subscriber(subscriber).new)
          end
        end
      end

      has_many :subscribers, :through => :subscriptions

      after_create do |subscribable|
        subscribable.subscriptions.create(subscribable.subscriber)
      end
    end

  end
end
