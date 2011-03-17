sites = []
sites << Site.find_or_create_by_name(
    :name                     => 'friskyhands',
    :launch                   => false,
    :analytics_account_number => 'UA-19948002-1',
    :analytics_domain_name    => '.friskyhands.com')

# All existing waves are on the friskyhands site.
sites.first.waves = Wave::Base.all

sites << Site.find_or_create_by_name(
    :name                     => 'positivelyfrisky',
    :launch                   => false,
    :analytics_account_number => 'UA-19948002-2',
    :analytics_domain_name    => '.positivelyfrisky.com')

sites << Site.find_or_create_by_name(
    :name                     => 'friskysoldiers',
    :launch                   => true,
    :analytics_account_number => 'UA-19948002-3',
    :analytics_domain_name    => '.friskysoldiers.com')

sites.each do |site|  
  unless site.waves.find_by_slug(Wave::CommunitiesController::DefaultWaveSlug).present?
    site.waves << Wave::Community.create(  
        :slug        => Wave::CommunitiesController::DefaultWaveSlug,
        :topic       => 'Community Wave',
        :description => '')
  end
end
