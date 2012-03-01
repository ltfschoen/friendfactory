namespace :ff do
  namespace :fix do
    task :photos_waves => :environment do
      ActiveRecord::Base.transaction do
        Posting::Photo.all.each do |photo|
          if personage = photo.user
            personage.find_or_create_photos_wave.postings << photo
          end
        end
      end
    end
  end
end
