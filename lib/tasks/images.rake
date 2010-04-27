namespace :spec do
  namespace :db do
    namespace :fixtures do
      namespace :images do
        desc "Load images into database using paperclip"
        task :load => :environment do
          require 'active_record/fixtures'
          ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)
          image_fixtures = Dir[File.join(Rails.root, 'spec', 'fixtures', 'images', '*.{jpg, jpeg, png}')]
          image_fixtures.each do |fixture|
            user = User.find_by_first_name(File.basename(fixture, '.*'))
            if user
              user.save # Make sure profile exists
              user.reload
              user.profile.build_avatar(:image => File.new(fixture))
              user.profile.save
            end
          end
        end
      end
    end
  end
end
