module Metadata
  class Author < Metadata::Base
    def self.ingest posting
      if user_id = posting.user_id
        connection.sadd "author:#{user_id}", posting[:id]
      end
    end
  end
end
