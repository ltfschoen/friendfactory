module Metadata
  module Ingest
    def self.ingestable? posting
      posting.respond_to? :ingest and posting.feed_id.blank?
    end
  end
end
