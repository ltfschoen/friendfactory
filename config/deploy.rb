set :application, "friskyfactory"

set :scm,        "git"
set :repository, "git://github.com/mjbamford/friskyfactory.git"
set :branch,     "master"
set :user,       "mrcap"
# set :runner,   "mrcap"

role :app, "friskyfactory.tagwaymedia.com"
role :web, "friskyfactory.tagwaymedia.com"
role :db,  "friskyfactory.tagwaymedia.com", :primary => true

set :deploy_to, '/home/mrcap/friskyfactory'
set :use_sudo,  false

ssh_options[:port] = 1968
ssh_options[:username] = 'mrcap'

set :mongrel_conf, "#{deploy_to}/current/config/mongrel_cluster.yml" 

after "deploy:symlink", "deploy:config_symlinks"
# after "deploy:symlink", "deploy:update_crontab"

namespace :deploy do
  task :config_symlinks do
    run <<-CMD
      ln -s #{shared_path}/system/database.yml #{latest_release}/config/database.yml
      ln -s #{shared_path}/system/mongrel_cluster.yml #{mongrel_conf}
    CMD
  end
  
  namespace :mongrel do
    [ :stop, :start ].each do |t|
      desc "#{t.to_s.capitalize} the mongrel appserver"
      task t, :roles => :app do
        # invoke_command checks the use_sudo variable
        # to determine how to run the mongrel_rails command
        invoke_command "mongrel_rails cluster::#{t.to_s} -C #{mongrel_conf}"
      end
    end

    task :restart, :roles => :app do
      invoke_command "mongrel_rails cluster::stop --clean -f -C #{mongrel_conf}"
      sleep 5
      invoke_command "mongrel_rails cluster::start --clean -C #{mongrel_conf}"
    end
  end

  # desc "Update crontab"
  # task :update_crontab, :roles => :app do
  #   run "cd #{release_path} && whenever --update-crontab #{application}"
  # end
  
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
end

namespace :local do
  desc "Dump production to sql file"
  task :production do
    run "mysqldump -u dpu -pdpu123 --ignore-table omgc_production.schema_migrations --complete-insert --no-create-info --skip-add-drop-table deeppool_production > #{deploy_to}/current/db/production.sql"
    get "#{deploy_to}/current/db/production.sql", "db/production.sql"
    #system "mysql -u dpu -pdpu123 deeppool_development < db/production.sql"
  end
  
  desc "Load production into development"
  task :reload do
    system "mysql -u omgcu -pomgcu123 omgc_development < db/production.sql"
  end
end
