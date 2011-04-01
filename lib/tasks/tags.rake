namespace :ff do
  namespace :tags do    
    desc 'Scrub user_info tags'
    task :refresh_all => :environment do
      Admin::Tag.refresh_all
    end    
  end
end