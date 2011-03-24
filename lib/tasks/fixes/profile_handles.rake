namespace :ff do
  namespace :fix do
    task :profile_handles => :environment do
      User.all.each do |user|
        user.waves.where(:type => Wave::Profile) do |wave|
          wave.handle = user.handle
          wave.first_name = user.first_name
          wave.last_name = user.last_name
          wave.save
        end
      end
    end    
  end
end
