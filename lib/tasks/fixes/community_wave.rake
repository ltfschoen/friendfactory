namespace :ff do
  namespace :fix do
    task :community_wave do
      Wave::Base.update_all('type = "Wave::Community"', 'type = "Wave::Shared"')
    end
  end
end
