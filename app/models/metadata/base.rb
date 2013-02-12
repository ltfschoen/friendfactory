module Metadata
  class Base
    class << self 
      def connection
        @connection ||= establish_connection
      end

      def ingest; end

      private

      def establish_connection
        Redis.new host: uri.host, port: uri.port, password: uri.password, driver: "hiredis"
      end

      def uri
        URI.parse ENV["REDISCLOUD_URL"] || "http://localhost:6379"
      end
    end
  end
end
