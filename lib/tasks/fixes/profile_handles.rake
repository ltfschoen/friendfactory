namespace :ff do
  namespace :fix do
    task :profile_handles => :environment do
      User.all.each do |user|
        user.profiles.each do |wave|
          profile_info = wave.profile_info
          profile_info.handle = user[:handle]
          profile_info.first_name = user[:first_name]
          profile_info.last_name = user[:last_name]
          profile_info.save
        end
      end
    end    
  end
end
