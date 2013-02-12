namespace :ff do
  namespace :migrate do
    task :postings_without_publications => :environment do
      posting_ids = Posting::Base.pluck("id").sort
      publishable_posting_ids = Publication.select("distinct posting_id").order("posting_id ASC").map(&:posting_id)
      puts (posting_ids - publishable_posting_ids).length
    end

    task :add_feed_id_to_postings => :environment do
      count = 0
      posting_ids = Publication.select("distinct posting_id").order("posting_id ASC").map(&:posting_id)
      Posting::Base.where(:id => posting_ids, :feed_id => nil).find_in_batches do |postings_batch|
        Posting::Base.transaction do
          postings_batch.each do |posting|
            if publication = posting.publishables.order(%q{"id" ASC}).first
              posting.update_attribute :feed_id, publication.wave_id
              count += 1
              print "#{count} " if count % 1000 == 0
            end
          end
        end
      end
    end
  end
end
