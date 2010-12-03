namespace :ff do
  namespace :fix do
    
    desc 'Publish all profile avatars to default wave'
    task :publish_to_default_wave => :environment do
      shared_wave = Wave::Base.find_by_slug(Wave::CommunitiesController::DefaultWaveSlug)
      if shared_wave
        avatar_ids = Wave::Profile.all.map{ |profile| profile.avatar_id }.compact
        avatar_ids_to_copy = avatar_ids - shared_wave.posting_ids
        shared_wave.posting_ids = shared_wave.posting_ids + avatar_ids_to_copy
        puts "copied #{avatar_ids_to_copy.sort * ' '}"
      end
    end
    
    desc 'Publish postings from default wave to individual profiles'
    task :publish_to_profiles => :environment do
      shared_wave = Wave::Base.find_by_slug(Wave::CommunitiesController::DefaultWaveSlug)
      cnt = 0
      if shared_wave
        postings = shared_wave.postings.only(Posting::Text, Posting::Photo)
        postings.each do |posting|
          profile = posting.user.profile
          unless profile.posting_ids.include?(posting.id)
            cnt += 1
            profile.postings << posting
            print "#{posting.id} "
            STDOUT.flush
          end
        end
        puts "Done" if cnt > 0
      end
    end
    
  end
end
