namespace :ff do
  namespace :metadata do
    desc "Ingest postings metadata"
    task :ingest => [ :environment ] do
      $redis.flushall
      Posting::Base.transaction do
        Posting::Base.find_each do |posting|
          if posting.respond_to? :create_metadata
            if posting.feed_id.blank?
              if publication = posting.publishables.order(%q{"id" ASC}).first
                feed_id = publication.wave_id
                posting.update_attribute :feed_id, feed_id
              end
            end
            posting.send :create_metadata
          end
        end
      end
    end
  end
end
