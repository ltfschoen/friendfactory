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
after "deploy:symlink", "deploy:thinking_sphinx"
after "deploy:symlink", "deploy:update_crontab"

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
  namespace :dump do
    desc "Dump production to local sql file"
    task :production do
      run "mysqldump -u ffu -pffu123 --ignore-table friskyfactory_production.schema_migrations --ignore_table friskyfactory_production.users_prelaunch --complete-insert --no-create-info --skip-add-drop-table friskyfactory_production > #{deploy_to}/current/db/production.sql"
      get "#{deploy_to}/current/db/production.sql", "db/production.sql"
      download "#{current_path}/public/system/images", "public/system", :via => :scp, :recursive => true, :preserve => true
      system "rake db:migrate VERSION=0 && rake db:migrate"
      system "mysql -u ffu -pffu123 friskyfactory_development < db/production.sql"
    end      
  end
end
