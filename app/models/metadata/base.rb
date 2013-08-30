module Metadata
  class Base
    include Redis::Objects

    class << self
      def connection
        Redis.current
      end

      def warn ingestable, message
        Rails.logger.warn "#{name} #{ingestable.class.name} #{message}"
      end
    end
  end
end
