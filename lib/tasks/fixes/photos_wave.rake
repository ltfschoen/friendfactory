namespace :ff do
  namespace :fix do
    task :photos_waves => :environment do
      ActiveRecord::Base.record_timestamps = false
      ActiveRecord::Base.transaction do
        Wave::Photo.delete_all
        Posting::Photo.includes(:user).all.each do |photo|
          if personage = photo.user
            personage.find_or_create_photos_wave.postings << photo
          end
        end
      end
      ActiveRecord::Base.record_timestamps = true
    end
  end
end
