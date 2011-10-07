namespace :ff do
  namespace :fixtures do
    
    desc "Load friskyfactory fixtures"
    task :load => [ :'ff:db:seed', :'load:models', :'load:taggables', :'load:avatars', :'load:photos', :'load:assets' ] # ts:rebuild
    
    namespace :load do
      task :models do
        ENV['FIXTURES_PATH'] = 'test/fixtures'
        Rake::Task[:'db:fixtures:load'].invoke
      end
            
      task :taggables => :environment do
        Admin::Tag.refresh_all
      end

      task :avatars => :environment do
        require 'active_record/fixtures'
        ActiveRecord::Base.establish_connection(Rails.env.to_sym)
        image_fixtures = Dir[File.join(Rails.root, 'test', 'fixtures', 'images', 'avatars', '*.{jpg,jpeg,png}')]
        image_fixtures.each do |fixture|          
          if user = UserInfo.find_by_first_name(File.basename(fixture, '.*').split('-')[0]).profile.user
            avatar = Posting::Avatar.new.tap do |avatar|
              avatar.image = File.new(fixture)
              avatar.user = user
              avatar.active = true
            end
            user.profiles.each { |profile| profile.postings << avatar }
            avatar.publish!
          end
        end        
      end
      
      task :photos => :environment do
        def files_grouped_by_first_name
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
            photo = Posting::Photo.new(:image => File.new(fixture)).tap { |photo| photo.user = user }
            album.postings << photo
            photo.publish!
          end
          album
        end

        require 'active_record/fixtures'
        ActiveRecord::Base.establish_connection(Rails.env.to_sym)        
        if wave = Wave::Base.find_by_slug(Wave::CommunitiesController::DefaultWaveSlug)          
          files_grouped_by_first_name.each do |files_by_first_name|
            if user = UserInfo.find_by_first_name(files_by_first_name.first).try(:user)
              wave.postings << new_album_with_photos(user, files_by_first_name.last)
            end
          end
        end
      end
      
      task :assets => :environment do
        def site_asset_dir
          File.join(Rails.root, 'test', 'fixtures', 'assets')
        end

        def site_names
          Dir[File.join(site_asset_dir, '*')].map{ |p| File.basename(p) }
        end
        
        def site_css(site_name)
          file = File.join(site_asset_dir, site_name, "#{site_name}.css")
          File.read(file) if File.exists?(file)
        end

        def site_asset_paths(site_name)
          Dir[File.join(site_asset_dir, site_name, '*.{jpg,jpeg,png}')]
        end
        
        require 'active_record/fixtures'
        ActiveRecord::Base.establish_connection(Rails.env.to_sym)
        site_names.each do |site_name|
          if site = Site.find_by_name(site_name)
            site.update_attribute(:css, site_css(site_name))
            site.assets.clear
            site_asset_paths(site_name).each do |site_asset_path|              
              asset = Asset::Image.new do |image|
                image.name = File.basename(site_asset_path, '.*')
                image.asset = File.new(site_asset_path)
              end
              site.assets << asset
            end
          end
        end
      end
      
    end
  end
end
