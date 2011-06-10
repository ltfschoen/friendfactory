namespace :ff do
  namespace :db do
    desc "Refresh development with production db and images from local dumps. DUMP_DATE=yyyymmdd"
    task :refresh => [ :'refresh:sql', :'refresh:images' ]      
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
  ENV['DUMP_DATE'] || most_recent_dump_timestamp || Time.now.strftime('%Y%m%d')
end

def most_recent_dump_timestamp
  Dir[File.join(Rails.root, 'db', 'dumps', '*')].map do |f|
    File.basename(f).match(/dump\.([0-9]{8})/)[1].to_i rescue nil
  end.compact.sort.last.to_s
end
