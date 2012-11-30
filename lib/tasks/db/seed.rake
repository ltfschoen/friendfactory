namespace :ff do
  namespace :db do
    desc "Seed the db regardless of migrations"
    task :seed => :environment do
      Rake::Task['db:seed'].clear_prerequisites
      Rake::Task['db:seed'].invoke
    end
  end
end
