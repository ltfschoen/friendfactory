namespace :ff do
  namespace :db do

    desc "Load all seeds and sites' CSS"
    task :seed => [ :'seed:load', :'seed:css' ]
    
    namespace :seed do      
      desc "Seed the db regardless of migrations"
      task :load => :environment do
        Rake::Task['db:seed'].clear_prerequisites
        Rake::Task['db:seed'].invoke
        Rake::Task['ff:db:seed:css'].invoke
      end

      desc "Seed the db with sites' CSS"
      task :css => :environment do
        Dir[File.join(Rails.root, 'db', 'seeds', '*.css')].each do |file|
          if site = Site.find_by_name(File.basename(file, '.css'))
            site.update_attribute(:css, IO.read(file))
          end
        end
      end
    end
    
  end
end


