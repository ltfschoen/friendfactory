set :application, "friskyfactory"

set :scm,        "git"
set :repository, "git@github.com:mjbamford/friskyfactory.git"
set :user,       "mrcap"
set :runner,     "mrcap"

role :app, "friskyfactory.tagwaymedia.com"
role :web, "friskyfactory.tagwaymedia.com"
role :db,  "friskyfactory.tagwaymedia.com", :primary => true

set :use_sudo,  false

ssh_options[:port] = 1968
ssh_options[:username] = 'mrcap'

after "deploy:symlink", "deploy:config_symlinks"
# after "deploy:symlink", "deploy:thinking_sphinx"
# after "deploy:symlink", "deploy:update_crontab"

task :staging do
  set :branch,         ENV['branch'] || 'master'
  set :rails_env,      'staging'
  set :deploy_to,      '/home/mrcap/friskyfactory/staging'
  set :mongrel_config, "#{deploy_to}/current/config/mongrel_cluster.yml" 
end

task :production do
  set :branch,         ENV['release']
  set :rails_env,      'production'
  set :deploy_to,      '/home/mrcap/friskyfactory/production'
  set :mongrel_config, "#{deploy_to}/current/config/mongrel_cluster.yml" 
end

namespace :deploy do
  task :config_symlinks do
    run <<-CMD
      ln -s #{shared_path}/config/database.yml #{latest_release}/config/database.yml &&
      ln -s #{shared_path}/config/mongrel_cluster.yml #{mongrel_config}
    CMD
  end
  
  namespace :mongrel do
    [ :stop, :start ].each do |t|
      desc "#{t.to_s.capitalize} the mongrel appserver"
      task t, :roles => :app do
        # invoke_command checks the use_sudo variable
        # to determine how to run the mongrel_rails command
        invoke_command "mongrel_rails cluster::#{t.to_s} -C #{mongrel_config}"
      end
    end

    task :restart, :roles => :app do
      invoke_command "mongrel_rails cluster::stop --clean -f -C #{mongrel_config}"
      sleep 5
      invoke_command "mongrel_rails cluster::start --clean -C #{mongrel_config}"
    end
  end

  desc "Custom restart task for mongrel cluster"
  task :restart, :roles => :app, :except => { :no_release => true } do
    deploy.mongrel.restart
  end

  desc "Custom start task for mongrel cluster"
  task :start, :roles => :app do
    deploy.mongrel.start
  end

  desc "Custom stop task for mongrel cluster"
  task :stop, :roles => :app do
    deploy.mongrel.stop
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

namespace :ff do
  desc "Dump production to local sql file"
  task :dump do
    require 'yaml'
    
    database  = YAML::load_file("config/database.yml")
    timestamp = Time.now.strftime('%Y%m%d')
    dump_filename = "dump.#{timestamp}.sql"
    tar_filename  = "images.#{timestamp}.tar.gz"
          
    on_rollback do
      delete "#{shared_path}/dumps/#{dump_filename}"
      delete "#{shared_path}/dumps/#{tar_filename}"
    end
    
    run "mysqldump -u #{database['production']['username']} -p#{database['production']['password']} -h #{database['production']['host']} #{database['production']['database']} > #{shared_path}/dumps/#{dump_filename}"
    run "cd #{current_path}/public/system && tar -czf #{shared_path}/dumps/#{tar_filename} images/*"
        
    get "#{shared_path}/dumps/#{dump_filename}", "db/#{dump_filename}"
    get "#{shared_path}/dumps/#{tar_filename}", "db/#{tar_filename}"
    # download "#{current_path}/public/system/images", "public/system", :via => :scp, :recursive => true, :preserve => true
        
    system "mysql -u #{database['development']['username']} -p#{database['development']['password']} #{database['development']['database']} < db/#{dump_filename}"
    system "tar -xf db/#{tar_filename} -C public/system"
  end  
end
