namespace :ff do
  namespace :fixtures do
    desc "Load all friskyfactory data"
    task :load => [ :'spec:db:fixtures:load', :'spec:db:fixtures:images:load', :'^^db:seed' ] # :'ts:rebuild'
  end
  
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
