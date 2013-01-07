module Metadata
  class Base
    def self.connection
      $redis
    end

    def self.ingest
      # Noop; override in descendant classes
    end

    def self.keys
      []
    end
  end
end
