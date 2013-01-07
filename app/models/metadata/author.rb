module Metadata
  class Author < Metadata::Base
    def self.ingest posting
      if user_id = posting.user_id
        connection.sadd "author:#{user_id}", posting[:id]
      end
    end

    def self.keys *user_ids
      user_ids.map { |user_id| "author:#{user_id}" }
    end
  end
end
