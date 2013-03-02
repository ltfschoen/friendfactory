namespace :ff do
  namespace :heroku do
    namespace :postgres do
      task :postgres_klass => [ :environment ] do
        self.class.send(:define_method, :postgres_klass) do |table_name|
          Class.new ActiveRecord::Base do
            self.table_name = table_name
            establish_connection \
              adapter: "postgresql",
              encoding: "unicode",
              host: "localhost",
              database: "friendfactory_development",
              pool: 5,
              username: "friendfactory",
              password: "ffu123"
          end
        end
      end
    end
  end
end
