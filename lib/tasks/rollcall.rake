namespace :ff do
  namespace :rollcall do
    task :fix => :environment do
      Posting::Avatar.all.each do |posting|
        print "#{posting.id}"
        if posting.user_id == 1
          profile = posting.waves.detect { |wave| wave.is_a?(Wave::Profile) }
          if profile.present? && (profile.user_id != posting.user_id)
            print ":#{posting.user_id}<=#{profile.user_id}"
            posting.user_id = profile.user_id
            posting.save
          end
        end
        print " "
        STDOUT.flush
      end
      puts "Done"
    end
  end
end
