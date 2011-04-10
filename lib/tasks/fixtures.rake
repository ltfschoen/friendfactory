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
            user.profiles.each { |profile| profile.postings << avatar }
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
          get_files_group_by_first_names.each do |files_by_first_name|
            if user = UserInfo.find_by_first_name(files_by_first_name.first).try(:user)
              wave.postings << new_album_with_photos(user, files_by_first_name.last)
            end
          end
        end
      end
      
    end
  end
end

def get_files_group_by_first_names
  filenames = Dir[File.join(Rails.root, 'test', 'fixtures', 'images', 'photos', '*.{jpg, jpeg, png}')]
  filenames.inject(Hash.new([])) do |memo, filename|
    first_name = File.basename(filename, '.*').split('-')[0]
    memo[first_name.to_sym] += [ filename ]
    memo
  end
end

def new_album_with_photos(user, fixtures)
  album = Wave::Album.new.tap { |wave| wave.state = :published }
  user.waves << album  
  fixtures.each do |fixture|            
    photo = Posting::Photo.new(:image => File.new(fixture), :user => user)
    album.postings << photo
    photo.publish!
  end
  album
end
