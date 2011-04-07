namespace :ff do
  namespace :fixtures do
    
    desc "Load friskyfactory fixtures"
    task :load => [ :'load:models', :'load:taggables', :'load:avatars', :'load:photos' ] # ts:rebuild
    
    namespace :load do      
      task :models do
        ENV['FIXTURES_PATH'] = 'test/fixtures'
        Rake::Task[:'db:fixtures:load'].invoke
      end
      
      task :taggables => :environment do
        (Wave::Profile.all +  Wave::Event.all).each do |taggable|
          taggable.set_tag_list && taggable.save
        end
      end

      task :avatars => :environment do
        require 'active_record/fixtures'
        ActiveRecord::Base.establish_connection(Rails.env.to_sym)
        image_fixtures = Dir[File.join(Rails.root, 'test', 'fixtures', 'images', 'avatars', '*.{jpg, jpeg, png}')]
        image_fixtures.each do |fixture|          
          if user = UserInfo.find_by_first_name(File.basename(fixture, '.*').split('-')[0]).profile.user
            avatar = Posting::Avatar.new.tap do |avatar|
              avatar.image = File.new(fixture)
              avatar.user = user
            end
            user.profiles.each { |profile| profile.avatars << avatar }
            avatar.publish!
          end
        end
        
        # Set last avatar of each user as active
        User.all.each do |user|
          user.profiles.each do |profile|            
            profile.avatars.last.update_attribute(:active, true) unless profile.avatars.empty?
          end
        end
      end
      
      task :photos => :environment do
        require 'active_record/fixtures'
        ActiveRecord::Base.establish_connection(Rails.env.to_sym)        
        if wave = Wave::Base.find_by_slug(Wave::CommunitiesController::DefaultWaveSlug)
          image_fixtures = Dir[File.join(Rails.root, 'test', 'fixtures', 'images', 'photos', '*.{jpg, jpeg, png}')]
          image_fixtures.each do |fixture|            
            if user = UserInfo.find_by_first_name(File.basename(fixture, '.*').split('-')[0]).try(:user)
              photo = Posting::Photo.new(:image => File.new(fixture), :user => user)
              wave.postings << photo
              photo.publish!
            end
          end
        end
      end
      
    end
  end
end
