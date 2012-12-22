module Metadata
  class Base
    def self.connection
      $redis
    end
    def self.ingest
      # Noop
    end
  end
end
