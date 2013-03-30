module Metadata
  class Wave < Metadata::Base
    def self.ingest ingestable
      if ingestable.respond_to? :wave_id and wave_id = ingestable.wave_id
        connection.sadd "wave:#{wave_id}", ingestable.id
      end
    end
  end
end
