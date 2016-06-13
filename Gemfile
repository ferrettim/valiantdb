source 'http://rubygems.org'
ruby "2.2.4" 

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails'
gem 'excon'
gem 'rack-cache'
# Assets
gem 'bootstrap-sass'
gem 'rails-assets-tether', '~> 1.1', '>= 1.1.1'
gem 'font-awesome-rails'
gem 'sprockets', '~> 3.0'
gem 'jasny-bootstrap-rails'
gem 'sass-rails'
gem 'coffee-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'yui-compressor'
gem 'sweet-alert', '~> 0.0.9'
gem 'sweet-alert-confirm'
gem 'fancybox-rails'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'execjs'
# gem 'therubyracer'
gem 'flexslider'
# Progress bar for turbolinks
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'nprogress-rails'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'
# Use Devise for user signin
gem 'devise'
gem 'devise-async'
gem 'gibbon', git: 'git://github.com/amro/gibbon.git'
gem 'omniauth-oauth2'
gem 'omniauth-facebook'
gem 'omniauth-google-oauth2', github: 'zquestz/omniauth-google-oauth2'
# Impersonate other users
gem 'switch_user'
# Follow users
gem 'socialization'
# Forms
gem 'simple_form'
gem 'mail_form'
# Autocomplete
#gem 'rails4-autocomplete'
gem 'rails-jquery-autocomplete'
# Rich text formatting
gem 'tinymce-rails'
# Messaging system
gem 'mailboxer'
gem 'select2-rails'
# Use Paperclip for image uploads
gem 'paperclip', github: 'thoughtbot/paperclip'
gem 'delayed_paperclip'
# Amazon SDK
gem 'aws-sdk-v1'
gem 'aws-sdk', '~> 2'

# Pagination
gem 'kaminari'
gem 'kaminari-bootstrap', '~> 3.0.1'
# Favorites system
gem 'acts_as_votable', '~> 0.10.0'
# Search functionality
gem 'searchkick'
# Rating system
gem 'ratyrate', :branch => 'development'
# Time zone support
gem 'local_time'
# Charts
gem 'dateslices'
gem 'chartkick'
gem 'active_median'
# Barcodes
gem 'barby'
# Passenger server
# gem 'passenger'
gem 'friendly_id', '~> 5.1.0'
# Stream
gem 'public_activity'
# Memcached
gem 'dalli'
# Papertrail
gem 'paper_trail', '~> 4.0.0'
# Currency conversion
gem 'money'
gem 'google_currency'
# News
gem 'feedjira'
# Security
gem 'rack-timeout'

group :development do
# Use sqlite3 as the database for Active Record
	gem 'sqlite3'
	gem 'guard-rails'
	gem 'guard-livereload'
	gem 'guard-spork'
	gem 'rack-livereload'
	gem 'guard-bundler'
	gem 'wdm', '>= 0.1.0' if Gem.win_platform?
	gem 'ruby_gntp'
	gem 'rb-notifu'
	gem 'childprocess', '0.3.6'
	gem 'better_errors'
	gem 'binding_of_caller'
	gem 'brakeman', :require => false
	gem 'quiet_assets'
	gem 'sys-proctable'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin]

group :production do
	# Postgres db
	gem 'pg'
	gem 'redis'
	gem 'rails_12factor'
	# Stats
	gem 'newrelic_rpm'
	# Compression
	gem 'heroku_rails_deflate'
	# Server
	gem "passenger", ">= 5.0.25", require: "phusion_passenger/rack_handler"
	# Background processing
	gem 'sidekiq'
	gem 'sinatra', require: false
	gem 'activejob'
	# Database panel
	gem 'pghero'
end
