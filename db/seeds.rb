sites = []
sites << Site.find_or_create_by_name(
    :name                     => 'friskyhands',
    :display_name             => 'FriskyHands',
    :analytics_account_number => 'UA-19948002-1',
    :analytics_domain_name    => '.friskyhands.com')

sites << Site.find_or_create_by_name(
    :name                     => 'positivelyfrisky',
    :display_name             => 'PositivelyFrisky',
    :invite_only              => true,
    :analytics_account_number => 'UA-19948002-2',
    :analytics_domain_name    => '.positivelyfrisky.com')

sites << Site.find_or_create_by_name(
    :name                     => 'friskysoldiers',
    :display_name             => 'FriskySoldiers',
    :launch                   => true,
    :analytics_account_number => 'UA-19948002-3',
    :analytics_domain_name    => '.friskysoldiers.com')
