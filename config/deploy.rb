# require 'bundler/capistrano'

set :application, 'friskyfactory'
#set :domain, 'ff01'
set :domain, 'friskyhands.com'

set :scm, 'git'
set :repository, 'git@github.com:mjbamford/friskyfactory.git'
set :user, 'mrcap'
set :runner, 'mrcap'
set :use_sudo, false

role :app, domain
role :web, domain
role :db,  domain, :primary => true

ssh_options[:port] = 1968
ssh_options[:username] = 'mrcap'

after 'deploy:symlink', 'deploy:config_symlinks'
# after "deploy:symlink", "deploy:thinking_sphinx"
# after "deploy:symlink", "deploy:update_crontab"
 
namespace :deploy do
  task :config_symlinks do
    run <<-CMD
      ln -s #{shared_path}/config/database.yml #{latest_release}/config/database.yml
    CMD
  end
  
  desc "Restart nginx"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_release}/tmp/restart.txt"
  end

  desc "Start nginx"
  task :start, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end

  desc "Stop nginx (noop)"
  task :stop, :roles => :app do
    # Do nothing
  end  

  desc "Update the crontab file"
  task :update_crontab, :roles => :app do
    run "cd #{release_path} && whenever --update-crontab #{application} --set environment=#{fetch(:rails_env)}"
  end
  
  desc "Full index of Sphinx models"
  task :thinking_sphinx, :roles => :app do
    run "cd #{current_path} && rake thinking_sphinx:stop RAILS_ENV=#{fetch(:rails_env)}"
    run "cd #{current_path} && rake thinking_sphinx:rebuild RAILS_ENV=#{fetch(:rails_env)}"
  end
end

desc 'Set staging environment'
task :staging do
  set :branch, ENV['branch'] || 'master'
  set :rails_env, 'staging'
  set :deploy_to, '/home/mrcap/friskyfactory/staging'
end

desc "Set production environment"
task :production do
  set :branch, ENV['release']
  set :rails_env, 'production'
  set :deploy_to, '/home/mrcap/friskyfactory/production'
end

namespace :ff do
  namespace :db do
    namespace :refresh do
      desc "Refresh sql and images on staging. DUMP_DATE=yyyymmdd"
      task :default do
        sql
        images          
      end

      desc "Refresh sql on staging. DUMP_DATE=yyyymmdd"
      task :sql do
        require 'yaml'
        staging
        database = YAML::load_file("config/database.yml")
        filename = File.join(deploy_to, '..', 'production', 'shared', 'dumps', "dump.#{dump_date}.sql")
        run "mysql -u #{database['staging']['username']} -p#{database['staging']['password']} #{database['staging']['database']} < #{filename}"
      end
      
      desc "Refresh images on staging. DUMP_DATE=yyyymmdd"
      task :images do
        staging
        filename = File.join(deploy_to, '..', 'production', 'shared', 'dumps', "images.#{dump_date}.tar.gz")
        run "cd #{current_path}/public/system && tar -czf #{filename} images/*"
      end
    end

    namespace :dumps do
      desc "Show available production dumps"
      task :default do
        production
        db_dumps = capture("ls #{File.join(shared_path, 'dumps', '*.sql')}").strip
        image_dumps = capture("ls #{File.join(shared_path, 'dumps', '*.tar.gz')}").strip
        puts db_dumps, image_dumps
      end

      desc "Remove old dumps. DUMP_DATE=yyyymmdd"
      task :cleanup do
        production
        if ENV['DUMP_DATE'].nil?
          puts "  * Usage: DUMP_DATE=yyyymmdd"
          exit
        end
        run "rm #{shared_path}/dumps/#{dump_filename}"
        run "rm #{shared_path}/dumps/#{tar_filename}"
      end
    end

    namespace :dump do
      desc "Dump production db and images to system/dumps"
      task :default do
        ff.db.dump.sql
        ff.db.dump.images
      end
      
      desc "Dump production sql to system/dumps"
      task :sql do
        require 'yaml'
        production
        database = YAML::load_file("config/database.yml")
        on_rollback { delete "#{shared_path}/dumps/#{dump_filename}" }
        run "mysqldump -u #{database['production']['username']} -p#{database['production']['password']} -h #{database['production']['host']} #{database['production']['database']} > #{shared_path}/dumps/#{dump_filename}"
      end
      
      desc "Dump production images to system/dumps"
      task :images do
        production        
        on_rollback { delete "#{shared_path}/dumps/#{tar_filename}" }
        run "cd #{current_path}/public/system && tar -czf #{shared_path}/dumps/#{tar_filename} images/*"
      end      
      
      namespace :download do
        desc "Download dumped production db and images to local. DUMP_DATE=yyyymmdd"
        task :default do
          sql
          images
        end
        
        desc "Download dumped production sql to local. DUMP_DATE=yyyymmdd"
        task :sql do
          production
          get "#{shared_path}/dumps/#{dump_filename}", "db/dumps/#{dump_filename}"
        end
        
        desc "Download dumped production images to local. DUMP_DATE=yyyymmdd"
        task :images do
          production
          get "#{shared_path}/dumps/#{tar_filename}", "db/dumps/#{tar_filename}"
        end
      end
    end    
  end
end

def dump_filename
  "dump.#{dump_date}.sql"
end

def tar_filename
  "images.#{dump_date}.tar.gz"
end

def dump_date
  @dump_date ||= (ENV['DUMP_DATE'] || Time.now.strftime('%Y%m%d'))
end