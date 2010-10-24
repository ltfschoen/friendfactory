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

namespace :fixtures do
  desc "Load all friskyfactory data"
  task :load => [ :'spec:db:fixtures:load', :'spec:db:fixtures:images:load', :'^^db:seed' ] # :'ts:rebuild'
end

namespace :production do  
  desc "Load production from local sql file"
  task :load => :environment do
    require 'yaml'
    database  = YAML::load_file("config/database.yml")
    timestamp = ENV['DUMP_DATE'] || Time.now.strftime('%Y%m%d')
    dump_filename = "dump.#{timestamp}.sql"
    tar_filename  = "images.#{timestamp}.tar.gz"
    sh "mysql -u #{database['development']['username']} -p#{database['development']['password']} #{database['development']['database']} < db/dumps/#{dump_filename}"
    sh "rm -rf public/system/images/* && tar -xf db/dumps/#{tar_filename} -C public/system"
  end
end
