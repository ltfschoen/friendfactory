namespace :ff do
  namespace :fixtures do
    
    desc "Load friskyfactory fixtures"
    task :load => [ :'load:models', :'load:images', :'db:seed' ] # ts:rebuild
    
    namespace :load do      
      desc "Load images using paperclip"
      task :images => :environment do
        require 'active_record/fixtures'
        ActiveRecord::Base.establish_connection(Rails.env.to_sym)
        image_fixtures = Dir[File.join(Rails.root, 'spec', 'fixtures', 'images', '*.{jpg, jpeg, png}')]
        image_fixtures.each do |fixture|
          user = User.find_by_first_name(File.basename(fixture, '.*'))
          if user
            avatar = Posting::Avatar.new(:image => File.new(fixture), :active => true, :user => user)
            user.profile.avatars << avatar
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
