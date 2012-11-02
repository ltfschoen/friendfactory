namespace :ff do
  namespace :heroku do
    namespace :postgres do
      task :sequences => [ :environment ] do
        postgres_klass = postgres_klass "users" # Any model will do
        table_names.each do |table_name|
          puts "#{table_name} "
          postgres_klass.connection.execute %Q{
            SELECT setval('#{table_name}_id_seq', (SELECT MAX(id) FROM "#{table_name}"));
          }
        end
      end

      def table_names
        [
          "accounts",
          "admin_tags",
          "assets",
          "biometric_people_values",
          "bookmarks",
          "delayed_jobs",
          "friendships",
          "invitation_confirmations",
          "invitations",
          "locations",
          "launch_users",
          "notifications",
          "personages",
          "postings",
          "publications",
          "resource_embeds",
          "resource_events",
          "resource_links",
          "signal_categories",
          "signal_categories_signals",
          "signals",
          "sites",
          "stylesheets",
          "subscriptions",
          "taggings",
          "tags",
          "users"
        ]
      end
    end
  end
end
