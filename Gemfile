source 'https://rubygems.org'
ruby '2.2.3'

# rails gems
gem 'rails', '4.2.5.2'
gem 'sprockets-rails', '< 3.0' # breaks Teaspoon

gem 'unicorn'
gem 'wicked'
gem 'friendly_id'
gem 'frozen_record', '~> 0.5.0'
gem 'paranoia', '~> 2.0'
gem 'responders'
gem 'render_anywhere', require: false
gem 'json-schema', '~> 2.6.0'
gem 'jbuilder'
gem 'wicked_pdf'
gem 'browser-timezone-rails'

# added validations
gem 'date_validator'
gem 'phonelib'

# exception tracking
gem 'rollbar', '~> 2.7.1'

# engines
gem 'devise'

# auth
gem 'omniauth-google-oauth2'
gem 'omniauth-facebook'

# asset gems
gem 'bootstrap-sass'
gem 'font-awesome-rails'
gem 'uglifier', '>= 1.3.0'
gem 'sass-rails', '~> 5.0'

# javascript gems
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails'
gem 'turbolinks', git: 'https://github.com/rails/turbolinks', branch: 'master'
gem 'twine-rails'
gem 'react-rails', git: 'https://github.com/reactjs/react-rails', branch: 'master'
gem 'browserify-rails'

group :production do
  gem 'pg'
  gem 'rails_12factor'
  gem 'newrelic_rpm'
  gem 'wkhtmltopdf-heroku'
end

group :development, :test do
  gem 'sqlite3'
  gem 'wkhtmltopdf-binary'
  gem 'byebug'
  gem 'faker'
  gem 'spring'
  gem 'bundler-audit', require: false
  gem 'teaspoon-jasmine', git: 'https://github.com/modeset/teaspoon', branch: 'master'
end

group :development do
  gem 'dotenv-rails'
  gem 'bullet'
  gem 'lol_dba'
  gem 'letter_opener'
  gem 'web-console', '~> 2.0'
end

group :test do
  gem 'mocha', :require => false
  gem 'minitest-rg'
  gem 'timecop'
  gem 'capybara'
  gem 'poltergeist'
  gem 'chunky_png'
  gem 'launchy'
  gem 'simplecov', :require => false
  gem 'minitest-ci', :git => 'git@github.com:circleci/minitest-ci.git'
end
