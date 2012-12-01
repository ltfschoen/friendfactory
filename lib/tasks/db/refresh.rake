namespace :ff do
  namespace :db do
    desc "Refresh development with production db and images from local dumps. DUMP_DATE=yyyymmdd"
    task :refresh => [ :'refresh:sql', :'refresh:images', :'refresh:assets' ]

    namespace :refresh do
      def timestamp
        ENV['DUMP_DATE'] || most_recent_dump_timestamp || Time.now.strftime('%Y%m%d')
      end

      def most_recent_dump_timestamp
        Dir[File.join(Rails.root, 'db', 'dumps', '*')].map do |f|
          File.basename(f).match(/dump\.([0-9]{8})/)[1].to_i rescue nil
        end.compact.sort.last.to_s
      end

      desc "Refresh development with local sql dump. DUMP_DATE=yyyymmdd"
      task :sql => :environment do
        require 'yaml'
        database  = YAML::load_file("config/database.yml")['development']
        dump_filename = "dump.#{timestamp}.sql"
        case database['adapter']
        when "mysql2"
          sh "mysql -u #{database['username']} -p#{database['password']} #{database['database']} < db/dumps/#{dump_filename}"
        when "postgresql"
          sh "psql -U #{database['username']} -d#{database['database']} -f db/dumps/#{dump_filename}"
        end
      end

      desc "Refresh development with images from local tar dump. DUMP_DATE=yyyymmdd"
      task :images => :environment do
        tar_filename = "images.#{timestamp}.tar.gz"
        if File.exists?("db/dumps/#{tar_filename}")
          # sh "rm -rf public/system/images/* && tar -xf db/dumps/#{tar_filename} -C public/system"
          sh "find public/system/images -type f -print0 | xargs -0 rm && tar -xf db/dumps/#{tar_filename} -C public/system"
        end
      end

      desc "Refresh development with assets from local tar dump. DUMP_DATE=yyyymmdd"
      task :assets => :environment do
        tar_filename = "assets.#{timestamp}.tar.gz"
        if File.exists?("db/dumps/#{tar_filename}")
          sh "rm -rf public/system/assets/* && tar -xf db/dumps/#{tar_filename} -C public/system"
        end
      end
    end
  end
end
