namespace :ff do
  namespace :heroku do
    namespace :postgres do
      task :postgres_klass => [ :environment ] do
        self.class.send(:define_method, :postgres_klass) do |table_name|
          Class.new ActiveRecord::Base do
            set_table_name table_name
            establish_connection \
              adapter: "postgresql",
              encoding: "unicode",
              host: ENV["HEROKU_POSTGRES_HOST"],
              database: ENV["HEROKU_POSTGRES_DATABASE"],
              pool: 5,
              username: ENV["HEROKU_POSTGRES_USERNAME"],
              password: ENV["HEROKU_POSTGRES_PASSWORD"]
          end
        end
      end
    end
  end
end
