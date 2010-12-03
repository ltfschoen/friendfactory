namespace :ff do
  namespace :db do
    desc "Refresh development with production db and images from local dumps. DUMP_DATE=yyyymmdd"
    task :refresh => [ :'refresh:sql', :'refresh:images', :slugs ]

    desc "Set the default wave"
    task :slugs => :environment do      
      wave = Wave::Base.find_by_slug('shared')
      if wave.present?
        wave.slug = Wave::CommunitiesController::DefaultWaveSlug
        wave.save
      end
    end
      
    namespace :refresh do
      desc "Refresh development with production sql from local. DUMP_DATE=yyyymmdd"
      task :sql => :environment do
        require 'yaml'
        database  = YAML::load_file("config/database.yml")
        dump_filename = "dump.#{timestamp}.sql"
        sh "mysql -u #{database['development']['username']} -p#{database['development']['password']} #{database['development']['database']} < db/dumps/#{dump_filename}"
      end
    
      desc "Refresh development with production images from local tar dump. DUMP_DATE=yyyymmdd"
      task :images => :environment do
        tar_filename = "images.#{timestamp}.tar.gz"
        if File.exists?("db/dumps/#{tar_filename}")
          sh "rm -rf public/system/images/* && tar -xf db/dumps/#{tar_filename} -C public/system"
        end
      end      
    end
  end
end

def timestamp
  ENV['DUMP_DATE'] || Time.now.strftime('%Y%m%d')
end
