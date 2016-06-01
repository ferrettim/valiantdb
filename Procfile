web: bundle exec puma -C config/puma.rb
worker: bundle exec sidekiq -q default -q mailers -q paperclip -e production -C config/sidekiq.yml