module Metadata
  class Origin < Metadata::Base
    def self.ingest posting
      if feed_id = posting.feed_id
        connection.sadd "origin:#{feed_id}", posting[:id]
      end
    end
  end
end
