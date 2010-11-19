namespace :ff do
  namespace :rollcall do
    task :fix => :environment do
      Posting::Avatar.all.each do |posting|
        if posting.user_id == 1
          profile = posting.waves.detect { |wave| wave.is_a?(Wave::Profile) }
          if profile.present? && (profile.user_id != posting.user_id)
            print "#{posting.id}:#{posting.user_id}<=#{profile.user_id} "
            posting.user_id = profile.user_id
            posting.save
          end
          STDOUT.flush
        end
      end
      puts "Done"
    end
  end
end
