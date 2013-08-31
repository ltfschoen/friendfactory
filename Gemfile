source "http://rubygems.org"

gem "rails", "3.2.14"

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

# Manually install and link nogoriki
# See http://nokogiri.org/tutorials/installing_nokogiri.html
# gem install nokogiri --
#   --with-xml2-include=/usr/local/Cellar/libxml2/2.9.1/libxml2
#   --with-xml2-lib=/usr/local/Cellar/libxml2/2.9.1/lib
#   --with-xslt-dir=/usr/local/Cellar/libxslt/1.1.28
#   --with-iconv-include=/usr/local/Cellar/libiconv/1.14/include
#   --with-xslt-lib=/usr/local/Cellar/libiconv/1.14/lib
# Also see:
# http://stackoverflow.com/questions/11668604/mountain-lion-libxml-nokogirii
gem 'nokogiri'
gem "pg"
gem 'unicorn'
gem "redis"
gem "hiredis"

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem "sass-rails", "~> 3.2.3"
  gem "coffee-rails", "~> 3.2.1"

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem "uglifier", ">= 1.0.3"
end

gem "jquery-rails"

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Bundle the extra gems:
# gem 'bj'

# Amazon S3
gem "paperclip", "~> 3.3.0"
gem "aws-sdk"

gem 'transitions', '>= 0.0.10', :require => [ 'transitions', 'active_record/transitions' ]
gem 'authlogic', '~> 3.1.0'
gem 'remotipart'

gem 'haml', '>= 3.1.2'
gem 'haml-rails'
gem 'sass', '>= 3.1.1'

gem 'acts-as-taggable-on', '~> 2.2.2'
gem "acts_as_tree"
gem "dynamic_form"

gem 'pusher', '~> 0.8.1'
gem 'will_paginate', '~> 3.0.2'
gem 'whenever', '~> 0.7.3', :require => false
gem 'embedly', '~> 1.5.2'
gem 'user_agent'

# Delayed job
gem "delayed_job_active_record"
gem "daemons"

gem 'bluecloth', '~> 2.0.10'

# gem 'responsalizr'
# gem 'exifr'
# gem 'sanitize'
# gem 'thinking-sphinx', '>= 1.3.16', :require => 'thinking_sphinx'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:

group :development do
  gem "thin"
  gem "foreman"
  gem "letter_opener"
end

group :development, :test do
  # gem "debugger"
  gem "rspec-rails"
  gem "factory_girl_rails", "~> 4.0"
  gem "webrat", ">= 0.7.2"
end

group :production do
  gem "memcache-client"
end
