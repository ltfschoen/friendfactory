namespace :ff do
  namespace :fixtures do
    
    desc "Load friskyfactory fixtures"
    task :load => [ :'load:models', :'load:avatars', :'load:photos', :'db:seed' ] # ts:rebuild
    
    namespace :load do      
      desc "Load avatars using paperclip"
      task :avatars => :environment do
        require 'active_record/fixtures'
        ActiveRecord::Base.establish_connection(Rails.env.to_sym)
        image_fixtures = Dir[File.join(Rails.root, 'spec', 'fixtures', 'images', 'avatars', '*.{jpg, jpeg, png}')]
        image_fixtures.each do |fixture|
          user = User.find_by_first_name(File.basename(fixture, '.*').split('-')[0])
          if user
            avatar = Posting::Avatar.new(:image => File.new(fixture), :user => user)
            user.profile.avatars << avatar
          end
        end
        
        # Set last avatar of each user as active
        User.all.each do |user|
          unless user.profile.avatars.empty?
            user.profile.avatars.last.update_attribute(:active, true)
          end
        end
      end
      
      desc "Load photos using paperclip"
      task :photos => :environment do
        require 'active_record/fixtures'
        ActiveRecord::Base.establish_connection(Rails.env.to_sym)
        image_fixtures = Dir[File.join(Rails.root, 'spec', 'fixtures', 'images', 'photos', '*.{jpg, jpeg, png}')]
        image_fixtures.each do |fixture|
          user = User.find_by_first_name(File.basename(fixture, '.*').split('-')[0])
          if user
            photo = Posting::Photo.new(:image => File.new(fixture), :user => user)
            user.profile.postings << photo
          end
        end
      end
    
      desc "Load models from yaml files"
      task :models do
        ENV['FIXTURES_PATH'] = 'spec/fixtures'
        Rake::Task[:'db:fixtures:load'].invoke
      end
    end
  end
end
