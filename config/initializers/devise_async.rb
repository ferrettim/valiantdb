Devise::Async.backend = :sidekiq
Devise::Async.enabled = false
Devise::Async.queue = :default