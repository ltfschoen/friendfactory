namespace :ff do
  namespace :fix do    
    task :admin_tags => :environment do      
      Admin::Tag.update_all "taggable_type = 'Wave::Profile'", "taggable_type = 'UserInfo'"
    end
  end
end
