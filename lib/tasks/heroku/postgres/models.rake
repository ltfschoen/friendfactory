namespace :ff do
  namespace :heroku do
    namespace :postgres do
      task :models => [ :environment ] do
        models.each do |model|
          if model.is_a? String
            migrate_classless_table model
          else
            migrate_model model
          end
        end
      end

      def models
        [
          Account,
          Admin::Tag,
          Asset::Base,
          Biometric::PersonValue,
          Bookmark,
          Friendship::Base,
          Invitation::Confirmation,
          Invitation::Base,
          LaunchUser,
          Location,
          Notification,
          Personage,
          Persona::Base,
          Posting::Base,
          Publication,
          Resource::Embed,
          Resource::Event,
          Resource::Link,
          Biometric::Domain,
          Biometric::DomainValue,
          Biometric::Value,
          Site,
          "sites_waves",
          "sites_users",
          Stylesheet,
          Subscription::Base,
          "taggings",
          "tags",
          User
        ]
      end

      def postgres_klass table_name
        Class.new ActiveRecord::Base do
          set_table_name table_name
          establish_connection \
            adapter: "postgresql",
            encoding: "unicode",
            database: "friendfactory_development",
            pool: 5,
            username: "friendfactory",
            password: "ffu123"
        end
      end

      def migrate_model model
        postgres_klass = postgres_klass model.table_name
        postgres_klass.record_timestamps = false
        postgres_klass.delete_all

        print "#{model.name} (#{model.count}) "
        idx = 0
        model.find_in_batches do |batch|
          postgres_klass.transaction do
            batch.each do |row|
              idx += 1
              attributes = row.attributes.dup
              id = attributes.delete "id"
              type = attributes.delete "type"
              dup = postgres_klass.new attributes
              dup.id = id
              dup.type = type if postgres_klass.column_names.include? "type"
              dup.save!
            end
            print "#{idx} " if idx > 0 && idx % 1000 == 0
            GC.start
          end
        end
        puts
      end

      def migrate_classless_table table_name
        postgres_klass = postgres_klass table_name
        postgres_klass.record_timestamps = false
        postgres_klass.delete_all
        postgres_klass.transaction do
          # Any model will do
          rows = User.connection.execute %Q{
            select * from `#{table_name}`;
          }
          print "#{table_name} (#{rows.count}) "
          idx = 0
          rows.each do |row|
            idx += 1
            print "#{idx} " if idx % 1000 == 0
            postgres_klass.create! Hash[*rows.fields.zip(row).flatten]
          end
        end
        puts
      end
    end
  end
end
