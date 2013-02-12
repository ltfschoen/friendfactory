namespace :ff do
  namespace :fix do
    task :photo_waves => :environment do
      Posting::Photo.record_timestamps = false
      ActiveRecord::Base.transaction do
        Wave::Photo.delete_all
        Posting::Photo.includes(:user).all.each do |photo|
          if personage = photo.user
            personage.find_or_create_photos_wave.postings << photo
          end
        end
      end
      Posting::Photo.record_timestamps = true
    end
  end
end
