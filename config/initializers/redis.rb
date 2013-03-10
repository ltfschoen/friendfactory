uri = URI.parse Rails.configuration.redis_url
database = Rails.configuration.redis_database
Redis.current = Redis.new host: uri.host, port: uri.port, password: uri.password, driver: "hiredis", db: database
