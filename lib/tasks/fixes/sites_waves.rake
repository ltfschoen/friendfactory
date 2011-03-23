namespace :ff do
  namespace :fix do
    task :sites_waves => :environment do
      Site.find_by_name('friskyhands').tap do |site|
        site.waves = Wave::Base.all
        site.users = User.all
      end

      Site.all.each do |site|
        if site.waves.where(:slug => Wave::CommunitiesController::DefaultWaveSlug).empty?
          site.waves << Wave::Community.create(  
              :slug        => Wave::CommunitiesController::DefaultWaveSlug,
              :topic       => 'Community Wave',
              :description => '',
              :state       => :published)
        end
      end
    end
  end
end
