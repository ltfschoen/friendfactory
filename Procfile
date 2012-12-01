web: bundle exec unicorn --port $PORT --config-file ./config/unicorn.rb --env $RACK_ENV
worker: bundle exec rake jobs:work
