namespace :spec do
  namespace :db do
    namespace :fixtures do
      namespace :images do
        desc "Load images into database using paperclip"
        task :load => :environment do
          require 'active_record/fixtures'
          ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)
          image_fixtures = Dir[File.join(Rails.root, 'spec', 'fixtures', 'images', '*.{jpg, jpeg, png}')]
          image_fixtures.each do |fixture|
            user = User.find_by_first_name(File.basename(fixture, '.*'))
            if user
              user.save # Make sure profile exists
              user.reload
              avatar = Posting::Avatar.new(:image => File.new(fixture), :active => true, :user => user)
              user.profile.avatars << avatar
            end
          end
        end        
      end
    end
  end
end

namespace :ff do
  namespace :fixtures do
    desc "Load all friskyfactory data"
    task :load => [ :'spec:db:fixtures:load', :'spec:db:fixtures:images:load', :'^^db:seed' ] # :'ts:rebuild'
  end

  namespace :db do    
    desc "Refresh development with production db and images from local dumps. Use DUMP_DATE=yyyymmdd"
    task :refresh => [ :'refresh:db', :'refresh:images' ]
  
    namespace :refresh do
      task :db => :environment do
        require 'yaml'
        database  = YAML::load_file("config/database.yml")
        dump_filename = "dump.#{timestamp}.sql"
        sh "mysql -u #{database['development']['username']} -p#{database['development']['password']} #{database['development']['database']} < db/dumps/#{dump_filename}"
      end
    
      desc "Refresh development with production images from local tar dump. Use DUMP_DATE=yyyymmdd"
      task :images => :environment do
        tar_filename = "images.#{timestamp}.tar.gz"
        sh "rm -rf public/system/images/* && tar -xf db/dumps/#{tar_filename} -C public/system"
      end
    end
  end
end

def timestamp
  ENV['DUMP_DATE'] || Time.now.strftime('%Y%m%d')
end
