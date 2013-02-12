namespace :ff do
  namespace :fix do
    task :profile_handles => :environment do
      User.all.each do |user|
        User.transaction do
          user.profiles.each do |profile|
            profile_resource = profile.resource
            profile_resource[:handle] = user[:handle]
            profile_resource[:first_name] = user[:first_name]
            profile_resource[:last_name] = user[:last_name]
            profile_resource.save!
          end
        end
      end
    end    
  end
end
