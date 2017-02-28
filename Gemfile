source 'https://rubygems.org'

gem "therubyracer"
gem "less-rails"
gem 'twitter-bootstrap-rails', '~> 4.0'
gem 'bootstrap-sass'

# Use pagination for displaying records in HTML and JSON.
gem 'will_paginate', '~> 3.0'
gem 'will_paginate-bootstrap'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '5.0.1'
# Use postgresql as the database for Active Record
gem 'pg'
# Use SCSS for stylesheets
gem 'sass-rails', '5.0.6'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.1'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby
gem 'devise'
gem 'simple_token_authentication'

gem 'aws-sdk'

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring',        group: :development

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Background scheduled tasks
gem "delayed_job", :git => 'git://github.com/collectiveidea/delayed_job.git' 
gem 'delayed_job_active_record'
gem "daemons"

# Use unicorn as the app server
gem 'unicorn'

# Add cron jobs
gem 'whenever', :require => false

# Use debugger
# gem 'debugger', group: [:development, :test]

group :development do
  # Use Capistrano for deployment
  gem 'capistrano'
  gem 'rvm-capistrano', :require => false
  # GUARD
  gem "guard"
  gem "yajl-ruby" # Just to optimize the guard perf
end

gem "rspec-rails", :group => [:development, :test]
