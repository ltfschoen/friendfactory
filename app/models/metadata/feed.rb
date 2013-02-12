module Metadata
  class Feed < Metadata::Base
    def self.ingest posting
      if feed_id = posting.feed_id
        connection.sadd "feed:#{feed_id}", posting.id
      end
    end
  end
end
