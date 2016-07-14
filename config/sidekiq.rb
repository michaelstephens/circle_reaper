require "sidekiq/web"

Sidekiq.configure_client do |config|
  config.redis = { url: ENV.fetch("REDIS_URL") }
end

Sidekiq.configure_server do |config|
  config.redis = { url: ENV.fetch("REDIS_URL") }
end

Sidekiq::Web.use Rack::Auth::Basic do |username, password|
  username == ENV.fetch("SIDEKIQ_USERNAME") && password == ENV.fetch("SIDEKIQ_PASSWORD")
end
