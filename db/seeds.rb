sites = []
sites << Site.find_or_create_by_name(
    :name                     => 'friskyhands',
    :analytics_account_number => 'UA-19948002-1',
    :analytics_domain_name    => '.friskyhands.com')

sites << Site.find_or_create_by_name(
    :name                     => 'positivelyfrisky',
    :invite_only              => true,
    :analytics_account_number => 'UA-19948002-2',
    :analytics_domain_name    => '.positivelyfrisky.com')

sites << Site.find_or_create_by_name(
    :name                     => 'friskysoldiers',
    :launch                   => true,
    :analytics_account_number => 'UA-19948002-3',
    :analytics_domain_name    => '.friskysoldiers.com')
