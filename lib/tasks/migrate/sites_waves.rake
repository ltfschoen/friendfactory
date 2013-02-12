namespace :ff do
  namespace :fix do
    task :sites_waves => :environment do
      Site.find_by_name('friskyhands').tap do |site|
        site.waves = Wave::Base.all if site.waves.empty?        
        site.users = User.all if site.users.empty?
      end

      Site.all.each do |site|
        if site.waves.where(:slug => Site::DefaultHomeWaveSlug).empty?
          site.waves << Wave::Community.create(
              :slug        => Site::DefaultHomeWaveSlug,
              :topic       => 'Community Wave',
              :description => '',
              :state       => :published)
        end
      end
    end
  end
end
