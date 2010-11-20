namespace :ff do
  namespace :wave do
    task :publish_avatars => :environment do
      shared_wave = Wave::Base.find_by_slug(Waves::BaseController::DefaultWaveSlug)
      if shared_wave
        avatar_ids = Wave::Profile.all.map{ |profile| profile.avatar_id }.compact
        avatar_ids_to_copy = avatar_ids - shared_wave.posting_ids
        shared_wave.posting_ids = shared_wave.posting_ids + avatar_ids_to_copy
        puts "copied #{avatar_ids_to_copy.sort * ' '}"
      end
    end
  end
end
