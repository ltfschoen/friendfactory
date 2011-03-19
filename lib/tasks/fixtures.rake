namespace :ff do
  namespace :fixtures do
    
    desc "Load friskyfactory fixtures"
    task :load => [ :'load:models', :'load:avatars', :'load:photos' ] # ts:rebuild
    
    namespace :load do      
      task :models do
        ENV['FIXTURES_PATH'] = 'spec/fixtures'
        Rake::Task[:'db:fixtures:load'].invoke
      end

      task :avatars => :environment do
        require 'active_record/fixtures'
        ActiveRecord::Base.establish_connection(Rails.env.to_sym)
        image_fixtures = Dir[File.join(Rails.root, 'spec', 'fixtures', 'images', 'avatars', '*.{jpg, jpeg, png}')]
        image_fixtures.each do |fixture|
          user = User.find_by_first_name(File.basename(fixture, '.*').split('-')[0])
          if user
            avatar = Posting::Avatar.new(:image => File.new(fixture), :user => user)
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
        wave = Wave::Base.find_by_slug(Wave::CommunitiesController::DefaultWaveSlug)
        if wave
          image_fixtures = Dir[File.join(Rails.root, 'spec', 'fixtures', 'images', 'photos', '*.{jpg, jpeg, png}')]
          image_fixtures.each do |fixture|
            user = User.find_by_first_name(File.basename(fixture, '.*').split('-')[0])
            if user
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
