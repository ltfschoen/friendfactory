namespace :ff do
  namespace :fix do
    task :subscriptions => :environment do
      def create_subscription(subscribable)
        begin
          subscribable.subscriptions.create(subscribable.subscriber) if subscribable.subscriber?
        rescue
          raise "Error #{subscribable.class.name}:#{subscribable.id}"
        end
      end

      Subscription::Base.delete_all
      Posting::Base.find_each { |posting| create_subscription(posting) }
      Friendship::Base.find_each { |friendship| create_subscription(friendship) }
    end
  end
end
