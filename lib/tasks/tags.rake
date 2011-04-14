namespace :ff do
  namespace :tags do    
    desc 'Delete and re-scrub all model tags'
    task :refresh_all => :environment do
      Admin::Tag.refresh_all
    end    
  end
end