Site.find_or_create_by_name(
    :name                     => 'friskyhands',
    :display_name             => 'FriskyHands',
    :analytics_account_number => 'UA-19948002-1',
    :analytics_domain_name    => '.friskyhands.com').create_default_wave

Site.find_or_create_by_name(
    :name                     => 'positivelyfrisky',
    :display_name             => 'PositivelyFrisky',
    :invite_only              => true,
    :analytics_account_number => 'UA-19948002-2',
    :analytics_domain_name    => '.positivelyfrisky.com').create_default_wave

Site.find_or_create_by_name(
    :name                     => 'friskyforces',
    :display_name             => 'FriskyForces',
    :launch                   => true,
    :analytics_account_number => 'UA-19948002-3',
    :analytics_domain_name    => '.friskyforces.com').create_default_wave

Site.find_or_create_by_name(
    :name                     => 'dizmdayz',
    :display_name             => 'Dizmdayz',
    :launch                   => false,
    :analytics_account_number => 'UA-19948002-4',
    :analytics_domain_name    => '.dizmdayz.com').create_default_wave
