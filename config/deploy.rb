require 'bundler/capistrano'
# require "whenever/capistrano"

set :application, 'friskyfactory'

set :scm, 'git'
set :repository, 'git@github.com:mjbamford/friendfactory.git'
set :git_shallow_clone, 1
set :user, 'mrcap'
set :runner, 'mrcap'
set :use_sudo, false
default_run_options[:pty] = true 

ssh_options[:port] = 1968
ssh_options[:username] = 'mrcap'

# set :whenever_command, "bundle exec whenever"

after 'deploy:symlink', 'deploy:config_symlinks'
# after "deploy:symlink", "deploy:thinking_sphinx"
 
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
    # Noop
  end

  desc "Full index of Sphinx models"
  task :thinking_sphinx, :roles => :app do
    run "cd #{current_path} && rake thinking_sphinx:stop RAILS_ENV=#{fetch(:rails_env)}"
    run "cd #{current_path} && rake thinking_sphinx:rebuild RAILS_ENV=#{fetch(:rails_env)}"
  end
  
  namespace :mysql do
    desc "Restart mysql"
    task :restart, :roles => :app do
      run "#{sudo} service mysql restart"
    end

    desc "Start mysql"
    task :start, :roles => :app do
      run "#{sudo} service mysql start"
    end

    desc "Stop mysql"
    task :stop, :roles => :app do
      run "#{sudo} service mysql stop"
    end
  end
end

desc 'Set staging environment'
task :staging do
  puts "*** deploying to staging"  
  role :app, 'ff01.friskyfactory.com'
  role :web, 'ff01.friskyfactory.com'
  role :db,  'ff01.friskyfactory.com', :primary => true
  set :branch do
    default_tag = ENV['release'] || 'master'
    tag = Capistrano::CLI.ui.ask "Pushed tag to deploy: [#{default_tag}] "
    tag = default_tag if tag.empty?
    tag
  end
  set :rails_env, 'staging'
  set :whenever_environment, 'staging'
  set :deploy_to, '/home/mrcap/friskyfactory/staging'
end

desc 'Set biorealism environment'
task :biorealism do
  puts "*** deploying to biorealism"  
  role :app, 'ff01.friskyfactory.com'
  role :web, 'ff01.friskyfactory.com'
  role :db,  'ff01.friskyfactory.com', :primary => true
  set :branch do
    default_tag = ENV['release'] || 'master'
    tag = Capistrano::CLI.ui.ask "Pushed tag to deploy: [#{default_tag}] "
    tag = default_tag if tag.empty?
    tag
  end
  set :rails_env, 'staging'
  # set :whenever_environment, 'staging'
  set :deploy_to, '/home/mrcap/friskyfactory/biorealism'
end

desc "Set production environment"
task :production do
  puts "*** deploying to \033[1;5;37;41m production \033[0m"
  role :app, 'ff02.friskyfactory.com'
  role :web, 'ff02.friskyfactory.com'
  role :db,  'ff02.friskyfactory.com', :primary => true  
  set :branch do
    default_tag = `git tag`.split("\n").last
    tag = Capistrano::CLI.ui.ask "Pushed tag to deploy: [#{default_tag}] "
    tag = default_tag if tag.empty?
    tag
  end
  set :rails_env, 'production'
  set :whenever_environment, 'production'
  set :deploy_to, '/home/mrcap/friskyfactory/production'
end

namespace :ff do
  namespace :db do
    namespace :refresh do
      desc "Refresh sql and images on staging. DUMP_DATE=yyyymmdd"
      task :default do
        sql
        images
        assets
        deploy.restart
      end

      task :sql do
        require 'yaml'
        staging
        database = YAML::load_file("config/database.yml")
        filename = File.join(shared_path, 'dumps', "dump.#{dump_date}.sql")
        run "mysql -u #{database['staging']['username']} -p#{database['staging']['password']} #{database['staging']['database']} < #{filename}"
      end
      
      task :images do
        staging
        filename = File.join(shared_path, 'dumps', "images.#{dump_date}.tar.gz")
        run "cd #{current_path} && rm -rf public/system/images/* && tar -xf #{filename} -C public/system"
      end

      task :assets do
        staging
        filename = File.join(shared_path, 'dumps', "assets.#{dump_date}.tar.gz")
        run "cd #{current_path} && rm -rf public/system/assets/* && tar -xf #{filename} -C public/system"
      end
    end

    namespace :dump do
      desc "Dump production db and images to system/dumps"
      task :default do
        ff.db.dump.sql
        ff.db.dump.images
        ff.db.dump.assets
      end
      
      task :sql do
        require 'yaml'
        production
        database = YAML::load_file("config/database.yml")
        on_rollback { delete "#{shared_path}/dumps/#{dump_filename}" }
        run "mysqldump -u #{database['production']['username']} -p#{database['production']['password']} -h #{database['production']['host']} #{database['production']['database']} > #{shared_path}/dumps/#{dump_filename}"
      end
      
      task :images do
        production        
        on_rollback { delete "#{shared_path}/dumps/#{images_tar_filename}" }
        run "cd #{current_path}/public/system && tar -czf #{shared_path}/dumps/#{images_tar_filename} images/*"
      end

      task :assets do
        production
        on_rollback { delete "#{shared_path}/dumps/#{assets_tar_filename}" }
        run "cd #{current_path}/public/system && tar -czf #{shared_path}/dumps/#{assets_tar_filename} assets/*"
      end

      desc "Show available production dumps"
      task :status do
        production
        db_dumps = capture("ls #{File.join(shared_path, 'dumps', '*.sql')}").strip
        tar_dumps = capture("ls #{File.join(shared_path, 'dumps', '*.tar.gz')}").strip
        puts db_dumps, tar_dumps
      end

      desc "Remove old dumps. DUMP_DATE=yyyymmdd"
      task :cleanup do
        production
        if ENV['DUMP_DATE'].nil?
          puts "  * Usage: DUMP_DATE=yyyymmdd"
          exit
        end
        run "rm #{shared_path}/dumps/#{dump_filename}"
        run "rm #{shared_path}/dumps/#{images_tar_filename}"
        run "rm #{shared_path}/dumps/#{assets_tar_filename}"        
      end            
    end
      
    namespace :download do
      desc "Download dumped production db and images to local. DUMP_DATE=yyyymmdd"
      task :default do
        sql
        images
        assets
      end
      
      task :sql do
        production
        get "#{shared_path}/dumps/#{dump_filename}", "db/dumps/#{dump_filename}"
      end
      
      task :images do
        production
        get "#{shared_path}/dumps/#{images_tar_filename}", "db/dumps/#{images_tar_filename}"
      end

      task :assets do
        production
        get "#{shared_path}/dumps/#{assets_tar_filename}", "db/dumps/#{assets_tar_filename}"
      end
    end
  end
end

def dump_filename
  "dump.#{dump_date}.sql"
end

def images_tar_filename
  "images.#{dump_date}.tar.gz"
end

def assets_tar_filename
  "assets.#{dump_date}.tar.gz"
end

def dump_date
  @dump_date ||= (ENV['DUMP_DATE'] || Time.now.strftime('%Y%m%d'))
end