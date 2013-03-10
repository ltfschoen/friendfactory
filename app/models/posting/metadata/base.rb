class Posting
  module Metadata
    class Base
      class << self
        def connection
          return @connection if defined? @connection
          @connection = establish_connection
        end

        private

        def establish_connection
          database = ENV["REDIS_DATABASE"] # If null, Redis will use it's default database (0).
          Redis.current = Redis.new host: uri.host, port: uri.port, password: uri.password, driver: "hiredis", db: database
        end

        def uri
          URI.parse ENV["REDISCLOUD_URL"] || "http://localhost:6379"
        end
      end
    end
  end
end
