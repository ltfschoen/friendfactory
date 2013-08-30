module Metadata
  class Wave < Metadata::Base
    class InvalidWaveIdError < Exception; end

    class << self
      def ingest ingestable
        wave = new ingestable.wave_id
        wave.postings << ingestable.id
        wave
      rescue NoMethodError
        warn ingestable, "missing attribute wave_id"
      rescue InvalidWaveIdError
        warn ingestable, "invalid wave_id"
      end
    end

    attr_reader :id

    set :postings

    def initialize id
      raise InvalidWaveIdError if id.nil?
      @id = id
    end
  end
end
