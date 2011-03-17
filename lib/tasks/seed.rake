namespace :ff do
  namespace :db do
    desc 'Load the seed data from db/seeds.rb regardless of migrations'
    task :seed => :environment do
      Rake::Task['db:seed'].clear_prerequisites
      Rake::Task['db:seed'].invoke
    end
  end
end