web: bundle exec passenger start -p $PORT --max-pool-size 3
worker: bundle exec sidekiq -q default -q mailers -q paperclip -e production -C config/sidekiq.yml