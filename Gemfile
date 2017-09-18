source 'http://rubygems.org'
ruby "2.4.0"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails'
gem 'railties'
gem 'excon'
gem 'rack'
gem 'rack-cache'
gem 'rack-attack'
# Assets
gem 'bootstrap-sass'
gem 'rails-assets-tether'
# gem 'font-awesome-rails'
gem 'sprockets'
gem 'jasny-bootstrap-rails'
gem 'sass-rails'
gem 'coffee-rails'
gem 'uglifier'
gem 'yui-compressor'
gem 'sweet-alert'
gem 'sweet-alert-confirm'
gem 'fancybox-rails'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'execjs'
# gem 'therubyracer'
gem 'flexslider'
# Progress bar for turbolinks
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'nprogress-rails'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc
# Use ActiveModel has_secure_password
gem 'bcrypt'
# Use Devise for user signin
gem 'devise'
gem 'devise-async'
gem 'gibbon', git: 'https://github.com/amro/gibbon.git'
gem 'omniauth-oauth2'
gem 'omniauth-facebook'
gem 'omniauth-google-oauth2', git: 'https://github.com/zquestz/omniauth-google-oauth2'
# Impersonate other users
gem 'switch_user'
# Follow users
gem 'socialization'
# Forms
gem 'simple_form'
gem 'mail_form'
# Autocomplete
gem 'rails4-autocomplete'
# Rich text formatting
gem 'tinymce-rails'
# Messaging system
gem 'mailboxer'
gem 'select2-rails'
# Use Paperclip for image uploads
gem 'paperclip', git: 'https://github.com/thoughtbot/paperclip'
gem 'delayed_paperclip'
# Amazon SDK
gem 'aws-sdk-v1'
gem 'aws-sdk', '~> 2'

# Pagination
gem 'kaminari'
gem 'kaminari-bootstrap'
# Rating system
gem 'ratyrate'
# Time zone support
gem 'local_time'
# Charts
gem 'dateslices'
gem 'chartkick'
gem 'active_median'
# Passenger server
# gem 'passenger'
gem 'friendly_id', '~> 5.1.0'
# Stream
gem 'public_activity'
# Memcached
gem 'dalli'
# Papertrail
gem 'paper_trail'
# Currency conversion
gem 'money'
gem 'google_currency'
# News
gem 'feedjira'
# Multilevel
gem 'cocoon'
# Scraper
# gem 'mechanize'
# Service Workers
gem "serviceworker-rails"

group :development do
# Use sqlite3 as the database for Active Record
	gem 'sqlite3'
	gem 'ruby_gntp'
	gem 'rb-notifu'
	gem 'childprocess', '0.3.6'
	gem 'better_errors'
	gem 'binding_of_caller'
	gem 'brakeman', :require => false
	gem 'sys-proctable'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
# gem 'tzinfo-data', platforms: [:mingw, :mswin]

group :production do
	# Postgres db
	gem 'pg'
	gem 'redis'
	# Server
	gem "puma-heroku"
	gem 'heroku-deflater', git: "https://github.com/romanbsd/heroku-deflater.git"
	# Tuning
	gem 'tunemygc'
	# Background processing
	gem 'sidekiq'
	gem 'sinatra', require: false
	gem 'activejob'
	gem 'scout_apm'
end
